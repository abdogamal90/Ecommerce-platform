class WishlistItemsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token


  def create
    product = Product.find(params[:product_id])
  
    if current_user.wishlist_products.include?(product)
      flash[:alert] = "#{product.name} is already in your wishlist"
    else
      current_user.add_to_wishlist(product)
      flash[:notice] = "#{product.name} added to wishlist"
    end
  
    respond_to do |format|
      format.html { redirect_back fallback_location: products_path, notice: flash[:notice] }
      format.turbo_stream
    end
  end

  def destroy
    wishlist_item = WishlistItem.find(params[:id])
    wishlist_item.destroy
  end

  # empty wishlist
  def delete
    current_user.wishlist_items.destroy_all
    redirect_to wishlist_items_path, notice: "Wishlist emptied"
  end

  
  def index
    @wishlist_items = current_user.wishlist_items
  end

end
