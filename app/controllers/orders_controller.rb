class OrdersController < ApplicationController
    def index
        @orders = current_user.orders.order(created_at: :desc)
    end

    def show
        @order = current_user.orders.find(params[:id])
    end
    


    def create
        @order = Order.new(order_params)

        if @order.save
        redirect_to @order
        else
        render :new
        end
    end

    # private

    # def order_params
    #     params.require(:order).permit(:name, :email, :address, :pay_type)
    # end
end