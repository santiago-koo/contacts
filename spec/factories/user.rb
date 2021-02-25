FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@demo.com"}
    password { "qweqweqwe" }
  end
end