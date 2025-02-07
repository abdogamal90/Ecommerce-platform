class Product < ApplicationRecord
    validates :name, :description, :price, :stock_quantity, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    
end
