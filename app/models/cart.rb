class Cart < ApplicationRecord
    has_many :cart_items
    has_many :products, through: :cart_items
    belongs_to :user

    def total_price
        cart_items.sum { |item| item.product.price * item.quantity }
    end

    def add_product(product_id)
        current_item = cart_items.find_by(product_id: product_id)
        if current_item
            current_item.quantity += 1
        else
            current_item = cart_items.build(product_id: product_id)
        end
        current_item
    end
end
