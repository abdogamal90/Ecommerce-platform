class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
      # if user exists
    elsif User.exists?(email: @user.email)
      flash[:alert] = 'User already exists.'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    # Check if the user is an admin
    if @user.admin?
      flash[:alert] = 'You cannot edit an admin user.'
      redirect_to users_path
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end
end