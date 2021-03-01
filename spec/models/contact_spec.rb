require 'rails_helper'

RSpec.describe Contact, type: :model do

  it { should validate_presence_of :email }
  it { should validate_presence_of :phone_number }
  it { should validate_presence_of :name }
  it { should validate_presence_of :birth_date }
  it { should validate_presence_of :address }
  it { should validate_presence_of :credit_card }

  it { should belong_to :user }
  it { should belong_to :contact_file }

end
