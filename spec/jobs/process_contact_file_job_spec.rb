require 'rails_helper'

RSpec.describe ProcessContactFileJob, type: :job do
  let(:user) { create(:user) }
  let(:process_contact_headers) do
    { email: 'email', name: 'nombre', birth_date: 'fecha_de_nacimiento', phone_number: 'telefono',
      address: 'direccion', credit_card: 'tarjeta_de_credito' }
  end
  let(:filename) { 'contacts.csv' }
  let(:file_path) { "spec/fixtures/#{filename}" }
  let(:contact_file) { create(:contact_file, user: user) }

  describe '#perform_now' do
    before do
      attach_content(contact_file, file_path, filename)
      ActiveJob::Base.queue_adapter = :test
    end

    context 'with wrong headers' do
      let(:process_contact_headers) do
        { email: 'email', name: 'name', birth_date: 'birth_date', phone_number: 'phone_number',
          address: 'address', credit_card: 'credit_card' }
      end

      it 'creates only failed contacts' do
        ProcessContactFileJob.perform_now(process_contact_headers, contact_file.id)
        expect(contact_file.contacts.count).to eq(0)
        expect(contact_file.failed_contacts.count).to eq(4)
      end
    end

    context 'whit correct correct headers' do
      it 'creates both failed and correct contacts' do
        ProcessContactFileJob.perform_now(process_contact_headers, contact_file.id)
        expect(contact_file.contacts.count).to eq(2)
        expect(contact_file.failed_contacts.count).to eq(2)
      end
    end
  end
end
