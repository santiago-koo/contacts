FactoryBot.define do
  factory :contact_file do
    sequence(:name) { |n| "contacts_#{n}.csv"}
    original_headers { [''] }
    status { :on_hold }
  end
end
