# Table Information
# Table name: users
#  id                     :bigint           not null, primary key
#  name                   :string
#  email                 :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string


class User < ApplicationRecord
  enum :role, { user: "user", admin: "admin" }
  after_initialize :set_default_role, if: :new_record?

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_one :cart
  has_many :orders, dependent: :destroy
  has_many :wishlist_items, dependent: :destroy
  has_many :wishlist_products, through: :wishlist_items, source: :product

  after_create :create_cart
  after_create :create_stripe_customer

  def create_stripe_customer
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    customer = Stripe::Customer.create(email: email)
    update(stripe_customer_id: customer.id)
  end

  def add_to_wishlist(product)
    wishlist_products << product
  end

  def create_cart
    Cart.create(user: self)
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
