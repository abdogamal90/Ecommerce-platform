# syntax=docker/dockerfile:1
# Use multi-stage build for smaller final image

# Define Ruby version
ARG RUBY_VERSION=3.3.2

#############################
# Base image for all stages
#############################
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base runtime dependencies (used by app in final image)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      sqlite3 \
      nodejs \
      npm \
      libpq5 \
    && npm install --global yarn \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set environment variables
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

#############################
# Build stage
#############################
FROM base AS build

# Add build tools required for native gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      git \
      build-essential \
      libpq-dev \
      pkg-config \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy the entire application
COPY . .

# Precompile bootsnap (faster boot times)
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets using dummy secret (not needed in final image)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

#############################
# Final image (runtime only)
#############################
FROM base

# Copy runtime app from build stage
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

# Entrypoint prepares the DB before starting
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port (Railway will override with $PORT)
EXPOSE 80


# Start Rails server via Thrust or default
CMD bash -c 'bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}'
