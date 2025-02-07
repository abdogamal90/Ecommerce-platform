class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @product = Product.find(params[:product_id])
    @cart = current_user.cart

    # Check if the product is already in the cart
    @cart_item = @cart.cart_items.find_by(product_id: @product.id)

    if @cart_item
      # Increase the quantity if the product is already in the cart
      @cart_item.update(quantity: @cart_item.quantity + 1)
    else
      # Add the product to the cart if it's not already there
      @cart_item = @cart.cart_items.create(product: @product, quantity: 1)
    end

    redirect_to cart_path, notice: "Product added to cart!"
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: "Product removed from cart."
  end
end
