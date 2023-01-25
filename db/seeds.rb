# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# add three owners and their profiles
o1 = Owner.create(
  email: 'tkhobbes@gmail.com',
  password: 'password',
)
o2 = Owner.create(
  email: 'jdoe@example.com',
  password: 'password'
)
o3 = Owner.create(
  email: 'jane@example.com',
  password: 'password'
)
Profile.create(
  name: 'tkhobbes',
  admin: true,
  owner_id: o1.id
)
Profile.create(
  name: 'jdoe',
  owner_id: o2.id
)
Profile.create(
  name: 'jane',
  owner_id: o3.id
)

# We need some book formats
BookFormat.create(name: 'Not specified', fallback: true)
BookFormat.create(name: 'Hardcover')
BookFormat.create(name: 'Softcover')
BookFormat.create(name: 'Paperback')
BookFormat.create(name: 'Coffee Table')
BookFormat.create(name: 'ebook')

# create 2 shelves for each owner
Owner.all.each do |u|
  Shelf.create(name: "Office #{u.name}", owner: u)
  Shelf.create(name: Faker::Lorem.word, owner: u)
end

# some genres
10.times do
  Genre.create(name: Faker::Book.unique.genre)
end

3.times do
  Tag.create(name: Faker::Color.unique.color_name, owner_id: Owner.first.id)
end

6.times do
  Tag.create(name: Faker::Color.unique.color_name, owner_id: Random.rand(2..3))
end

# 1 explicit publisher
Publisher.create(
  name: 'AAAA Press',
  location: 'Dornach'
)

# 29 publishers to which we distribute books randomly
29.times do
  Publisher.create(
    name: Faker::Book.unique.publisher,
    location: Faker::Address.city
  )
end

# some authors
genders = ['male', 'female']

Author.create(
  first_name: 'John Ronald Reuel',
  last_name: 'Tolkien',
  born: 1892,
  died: 1973,
  gender: 'male',
  rating: 5,
  tags: Owner.first.tags.sample(1)
)

Author.first.portrait.attach(io: File.open("db/sample/authors/tolkien.jpg"), filename: 'tolkien.jpg')

60.times do |index|
  age = Random.rand(20..100)
  if [true, false].sample
    died = Random.rand(1920..2022)
    birth = died - age
  else
    birth = Random.rand(1930..2000)
  end
  author = Author.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.unique.last_name,
    born: birth,
    died: died,
    gender: genders.sample,
    rating: Random.rand(0..5),
    tags: Tag.all.sample(2)
  )

  portrait_number = index.modulo(10) + 1

  author.portrait.attach(io: File.open("db/sample/authors/author#{portrait_number}.jpg"), filename: 'portrait.jpg')
end

# the first book has no cover image and it's alphabetically the first
Book.create(
  title: 'AAA Title comes first',
  year: Random.rand(1920..2020),
  rating: Random.rand(0..5),
  condition: Random.rand(0..5),
  synopsis: "<b>Synopsis</b><br /><p>#{Faker::Lorem.paragraphs(number: 10).join(' ')}</p>",
  book_format_id: 2,
  owner_id: Owner.first.id,
  shelf: Owner.first.shelves.sample,
  genres: Genre.all.sample(3),
  tags: Owner.first.tags.sample(1),
  publisher: Publisher.first,
  country: 'Switzerland',
  authors: Author.where(last_name: 'Tolkien'),
  pages: 1000,
  isbn: 'dummy-isbn-1',
)

99.times do |index|
  owner = Owner.find(Random.rand(1..3))

  book = Book.create(
    title: Faker::Book.unique.title,
    year: Random.rand(1920..2020),
    rating: Random.rand(0..5),
    condition: Random.rand(0..5),
    synopsis: "<p>#{Faker::Lorem.paragraphs(number: 20).join(' ')}</p>",
    book_format_id: Random.rand(1..6),
    owner_id: owner.id,
    shelf: owner.shelves.sample,
    genres: Genre.all.sample(3),
    tags: owner.tags.sample(2),
    country: Faker::Address.country,
    publisher: Publisher.all.sample,
    authors: Author.all.sample(1),
    pages: Random.rand(100..1000),
    isbn: Faker::Code.unique.isbn
  )

  cover_number = index.modulo(10) + 1

  book.cover.attach(io: File.open("db/sample/images/cover-#{cover_number}.jpg"), filename: 'cover.jpg')
end
