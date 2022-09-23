# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# add two users
User.create(
  name: 'tkhobbes',
  email: 'tkhobbes@gmail.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)
User.create(
  name: 'jdoe',
  email: 'jdoe@example.com',
  password: 'password',
  password_confirmation: 'password',
  activated: true,
  activated_at: Time.zone.now
)
User.create(
  name: 'jane',
  email: 'jane@example.com',
  password: 'password',
  password_confirmation: 'password',
  activated: true,
  activated_at: Time.zone.now
)

# We need some book formats
BookFormat.create(name: 'Not specified', fallback: true)
BookFormat.create(name: 'Hardcover')
BookFormat.create(name: 'Softcover')
BookFormat.create(name: 'Paperback')
BookFormat.create(name: 'Coffee Table')
BookFormat.create(name: 'ebook')

# some genres
10.times do
  Genre.create(name: Faker::Book.unique.genre)
end

3.times do
  Tag.create(name: Faker::Color.unique.color_name, user_id: User.first.id)
end

6.times do
  Tag.create(name: Faker::Color.unique.color_name, user_id: Random.rand(2..3))
end

# the first book has no cover image and it's alphabetically the first
Book.create(
  title: 'AAA Title comes first',
  year: Random.rand(1920..2020),
  rating: Random.rand(0..5),
  condition: Random.rand(0..5),
  synopsis: "<b>Synopsis</b><br /><p>#{Faker::Lorem.paragraphs(number: 10).join(' ')}</p>",
  book_format_id: 2,
  user_id: User.first.id,
  genres: Genre.all.sample(3),
  tags: User.first.tags.sample(1)
)

99.times do |index|
  user = User.find(Random.rand(1..3))

  book = Book.create(
    title: Faker::Book.unique.title,
    year: Random.rand(1920..2020),
    rating: Random.rand(0..5),
    condition: Random.rand(0..5),
    synopsis: "<p>#{Faker::Lorem.paragraphs(number: 20).join(' ')}</p>",
    book_format_id: Random.rand(1..6),
    user_id: user.id,
    genres: Genre.all.sample(3),
    tags: user.tags.sample(2)
  )

  cover_number = index.modulo(10) + 1

  book.cover.attach(io: File.open("db/sample/images/cover-#{cover_number}.jpg"), filename: 'cover.jpg')
end
