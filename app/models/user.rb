class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :cart
  has_many :orders, dependent: :destroy
  after_create :create_cart
  after_create :create_stripe_customer

  def create_stripe_customer
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    customer = Stripe::Customer.create(email: email)
    update(stripe_customer_id: customer.id)
  end


  def create_cart
    Cart.create(user: self)
  end
end
