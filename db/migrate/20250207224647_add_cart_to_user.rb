class AddCartToUser < ActiveRecord::Migration[8.0]
  def change
    # Step 1: Add the column without the `null: false` constraint
    add_reference :users, :cart, foreign_key: true

    # Step 2: Allow null values for the column
    change_column_null :users, :cart_id, true
    
  end
end
