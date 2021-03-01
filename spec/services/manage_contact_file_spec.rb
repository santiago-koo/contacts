require 'rails_helper'

RSpec.describe ManageContactFile do

  let(:user) { create(:user) }

  context "call" do
    it 'upload csv' do
      filename = "contacts.csv"
      file_path = "spec/fixtures/#{filename}"
      result = ::ManageContactFile.new({file_path: file_path, user: user, filename: filename}).call
      expect(result.success?).to eq(true)
      expect(ContactFile.count).to eq(1)
    end

    it 'non existent csv file' do
      filename = "non_existent.csv"
      file_path = "spec/fixtures/#{filename}"
      result = ::ManageContactFile.new({file_path: file_path, user: user, filename: filename}).call
      expect(result.success?).to eq(false)
      expect(ContactFile.count).to eq(0)
    end
  end
  
end