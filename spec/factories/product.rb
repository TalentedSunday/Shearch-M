FactoryBot.define do
  factory :product do
    sequence(:title) { |n| "Sam#{n}" }
    tags { ''}
    description { |n| "samsmith#{n}@gmail.com" }
    country { '123 Happy St' }
    price { |n| "#{n}"  }
  end
end
