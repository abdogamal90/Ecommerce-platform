class ProfilesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    @user = current_user
    @wishlist_items = @user.wishlist_items.includes(:product)
    @products = Product.paginate(page: params[:page], per_page: 5)
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to profile_path
    else
      flash[:alert] = "Error updating profile"
      render :show
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end
