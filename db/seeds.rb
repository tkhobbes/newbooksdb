# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

100.times do
  Book.create(
    title: Faker::Book.title,
    year: Random.rand(1920..2020),
    rating: Random.rand(0..5),
    condition: Random.rand(0..5)
  )
end
