FactoryBot.define do
  factory :contact_file do
    sequence(:name) { |n| "contact_file_#{n}.csv" }
    original_headers { [''] }
    status { :on_hold }

    trait :finished do
      status { :finished }
    end

    trait :failed do
      status { :failed }
    end

    factory :contact_file_with_contacts do
      transient do
        contacts_count { 2 }
      end

      after(:create) do |contact_file, evaluator|
        create_list(:contact, evaluator.contacts_count, contact_file: contact_file)
        contact_file.reload
      end
    end

    factory :contact_file_with_failed_contacts do
      transient do
        failed_contacts_count { 2 }
      end

      after(:create) do |contact_file, evaluator|
        create_list(:failed_contact, evaluator.failed_contacts_count, contact_file: contact_file)
        contact_file.reload
      end
    end
  end
end
