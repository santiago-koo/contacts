require 'rails_helper'

RSpec.describe ManageContactsCsv do
  let(:user) { create(:user) }
  let(:contact_file) { create(:contact_file, user_id: user.id, original_headers: ['']) }

  context 'call' do
    it 'upload csv' do
      file_path = 'spec/fixtures/contacts.csv'
      headers = {
        email: 'email',
        name: 'name',
        birth_date: 'birth_date',
        phone_number: 'phone_number',
        address: 'address',
        credit_card: 'credit_card',
      }

      # result = ::ManageContactsCsv.new({headers: process_csv_params, contact_file: contact_file, user: user}).call

      # expect(result.success?).to eq(true)
      # expect(Contact.count).to eq(1)
    end

    it 'do not allow process already processed contact files' do
      processed_contact_file = ContactFile.new(status: :finished)
      processed_contact_file.save(validate: false)

      result = ::ManageContactsCsv.new({ headers: {}, contact_file: processed_contact_file, user: user }).call()
      expect(result.success?).to eq(false)
      expect(result.payload[:error]).to eq('Contact file has been processed')
      expect(Contact.where(contact_file_id: processed_contact_file.id).count).to eq(0)
    end
  end
end
