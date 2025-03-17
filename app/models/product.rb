class Product < ApplicationRecord

    has_many :cart_items
    has_many :carts, through: :cart_items
    has_many :wishlist_items, dependent: :destroy
    has_many :users_wish_list_items, through: :wishlist_items, source: :user


    validates :name, :description, :price, :stock_quantity, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    def add_to_wishlist(user, product)
        user.add_to_wishlist(product)
    end
    
end
