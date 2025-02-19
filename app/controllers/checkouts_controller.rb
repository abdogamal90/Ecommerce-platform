class CheckoutsController < ApplicationController

  before_action :authenticate_user!

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  def create
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)

    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: @cart_items.map do |cart_item|
        {
          price_data: {
            currency: 'usd',
            product_data: { name: cart_item.product.name },
            unit_amount: (cart_item.product.price * 100).to_i
          },
          quantity: cart_item.quantity
        }
      end,
      mode: 'payment',
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url
    })

    redirect_to session.url, allow_other_host: true
  end

  def success
    session_id = params[:session_id]
    session = Stripe::Checkout::Session.retrieve(session_id)

    if session.payment_status == 'paid'
      @cart = current_user.cart
      @cart_items = @cart.cart_items.includes(:product)

      order = current_user.orders.create!(total_price: @cart.total_price, status: :completed)

      @cart_items.each do |cart_item|
        order.order_items.create!(product: cart_item.product, quantity: cart_item.quantity, price: cart_item.product.price)
      end

      @cart.cart_items.destroy_all # Clear cart after order creation

      redirect_to order_path(order), notice: 'Payment successful!'
    else
      redirect_to cart_path, alert: 'Payment not completed. Please try again.'
    end
  rescue Stripe::StripeError => e
    redirect_to cart_path, alert: e.message
  end

  def cancel
    redirect_to cart_path, alert: "Payment was canceled."
  end
end