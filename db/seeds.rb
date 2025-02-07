10.times do
    Product.create(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph,
      price: Faker::Commerce.price(range: 10..100.0),
      stock_quantity: Faker::Number.between(from: 1, to: 100)
    )
end