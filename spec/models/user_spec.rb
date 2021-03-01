require 'rails_helper'

RSpec.describe User, type: :model do

  context "validations" do
    it { should validate_presence_of :email }
  end

  context "relationships" do
    it { should have_many(:contacts) }
    it { should have_many(:contact_files) }
  end

end
