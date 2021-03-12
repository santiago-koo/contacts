FactoryBot.define do
  factory :contact do
    sequence(:email) { |n| "test_#{n}@email.con" }
    sequence(:name) { |n| "name_#{n}" }
    phone_number { '(+00) 000-000-00-00' }
    birth_date { '1995-12-12' }
    address { 'fake street 123' }
    credit_card { '4111111111111111' }
    last_four_credit_card_numbers { credit_card.last(4) }
    franchise { 'Visa' }
  end
end
