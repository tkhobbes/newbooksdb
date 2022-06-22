# Users factory
FactoryBot.define do
  factory :hobbit, class: Book do
    title { 'The Hobbit' }
    year { 1937 }
    rating { 5 }
    condition { 4 }
  end

  factory :a_prefix_book, class: Book do
    title { 'A wonderful Life of an Ant' }
    year { 1980 }
  end

  factory :random_book, class: Book do
    title { Faker::Book.title }
    year { Random.rand(1920..2020) }
    rating { Random.rand(0..5) }
    condition { Random.rand(0..5) }
  end
end
