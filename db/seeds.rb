require 'faker'

puts "Seeding data..."

# Clean up
CartItem.delete_all
WishlistItem.delete_all
OrderItem.delete_all
Order.delete_all
Product.delete_all
User.delete_all
Cart.delete_all

# Products
100.times do
  Product.create!(
    name: Faker::Commerce.unique.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price(range: 10..100.0),
    stock_quantity: rand(1..100)
  )
end
products = Product.all

# Users & Carts
50.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "password123",
    password_confirmation: "password123",
    name: Faker::Name.name
  )

  cart = Cart.create!(user: user)

  # Wishlist Items
  rand(2..6).times do
    WishlistItem.create!(
      user: user,
      product: products.sample
    )
  end

  # Cart Items
  rand(1..5).times do
    CartItem.create!(
      cart: cart,
      product: products.sample,
      quantity: rand(1..3)
    )
  end

  # Orders with Items
  rand(1..3).times do
    order = Order.create!(
      user: user,
      total_price: 0,
      status: rand(0..2)
    )
    total = 0

    rand(1..4).times do
      product = products.sample
      quantity = rand(1..3)
      price = product.price

      OrderItem.create!(
        order: order,
        product: product,
        quantity: quantity,
        price: price
      )
      total += quantity * price
    end

    order.update!(total_price: total)
  end
end

puts "✅ Done seeding."
