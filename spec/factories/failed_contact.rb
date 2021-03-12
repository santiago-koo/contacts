FactoryBot.define do
  factory :failed_contact do
    sequence(:email) { |n| "invalid_email_#{n}" }
    sequence(:name) { |n| "invalid_name_#{n}" }
    sequence(:phone_number) { |n| "invalid_phone_number_#{n}" }
    sequence(:birth_date) { |n| "invalid_birth_date_#{n}" }
    sequence(:address) { |n| "invalid_address_#{n}" }
    sequence(:credit_card) { |n| "4111111111111111#{n}" }
    last_four_credit_card_numbers { 'invalid' }
    sequence(:franchise) { |n| "invalid_franchise_#{n}" }
  end
end
