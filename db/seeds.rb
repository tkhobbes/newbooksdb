# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# the first book has no cover image and it's alphabetically the first
Book.create(
  title: 'AAA Title comes first',
  year: Random.rand(1920..2020),
  rating: Random.rand(0..5),
  condition: Random.rand(0..5),
  synopsis: "<b>Synopsis</b><br /><p>#{Faker::Lorem.paragraphs(number: 10).join(' ')}</p>"
)

99.times do |index|
  book = Book.create(
    title: Faker::Book.title,
    year: Random.rand(1920..2020),
    rating: Random.rand(0..5),
    condition: Random.rand(0..5),
    synopsis: "<p>#{Faker::Lorem.paragraphs(number: 20).join(' ')}</p>"
  )

  cover_number = index.modulo(10) + 1

  book.cover.attach(io: File.open("db/sample/images/cover-#{cover_number}.jpg"), filename: 'cover.jpg')
end
