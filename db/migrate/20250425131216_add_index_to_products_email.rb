class AddIndexToProductsEmail < ActiveRecord::Migration[8.0]
  def change
    add_index :products, :name, unique: true
  end
end
