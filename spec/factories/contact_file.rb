FactoryBot.define do
  factory :contact_file do
    sequence(:name) { |n| "contact_file_#{n}.csv"}
    original_headers { [''] }
    status { :on_hold }

    trait :finished do
      status { :finished }
    end

    trait :failed do
      status { :failed }
    end
  end
end
