require 'rails_helper'

RSpec.describe ManageContactsCsv do
  let(:user) { create(:user) }
  let(:contact_file) { create(:contact_file, user_id: user.id) }

  describe '#call' do
    context 'process a csv file' do
      let(:headers) { headers }
      let(:filename) { 'contacts.csv' }
      let(:file_path) { "spec/fixtures/#{filename}" }
      let(:file_content) { normalize_csv_file(file_path) }
      let(:result) { ::ManageContactsCsv.new({ headers: headers, contact_file: contact_file }).call }
      let(:contacts_count) { Contact.where(contact_file: contact_file).count }
      let(:failed_contacts_count) { FailedContact.where(contact_file: contact_file).count }

      context 'when headers match and filename is correct' do
        let(:headers) { { email: 'email', name: 'nombre', birth_date: 'fecha_de_nacimiento', phone_number: 'telefono', address: 'direccion', credit_card: 'tarjeta_de_credito' } }

        it "the contact file status is 'finished' and 2 contacts and 2 failed contacts were created" do
          contact_file.csv_file.attach({ io: StringIO.new(file_content), filename: filename })

          expect(result.success?).to eq(true)
          expect(contact_file.status).to eq('finished')
          expect(contacts_count).to eq(2)
          expect(failed_contacts_count).to eq(2)
        end
      end

      context 'when headers is an invlaid value and the filename is correct' do
        let(:headers) { ['something_incorrect'] }

        it "the contact file status is 'failed' and neither contacts nor failed contacts were created" do
          contact_file.csv_file.attach({ io: StringIO.new(file_content), filename: filename })

          expect(result.success?).to eq(false)
          expect(contact_file.status).to eq('failed')
          expect(contacts_count).to eq(0)
          expect(failed_contacts_count).to eq(0)
        end
      end

      context "when headers doesn't match but the filename is correct" do
        let(:headers) { { email: 'email', name: 'name', birth_date: 'birth_date', phone_number: 'phone_number', address: 'address', credit_card: 'credit_card' } }

        it "the contact file status is 'failed' and 4 failed contacts were created" do
          contact_file.csv_file.attach({ io: StringIO.new(file_content), filename: filename })

          expect(result.success?).to eq(true)
          expect(contact_file.status).to eq('failed')
          expect(failed_contacts_count).to eq(4)
        end
      end

      context 'when a contact file already has been processed' do
        let(:processed_contact_file) { ContactFile.new(status: :finished) }
        let(:result) { ::ManageContactsCsv.new({ headers: {}, contact_file: processed_contact_file }).call }

        it 'raise an error message and neither contacts nor failed contacts are created' do
          processed_contact_file.save(validate: false)

          expect(result.success?).to eq(false)
          expect(result.payload[:error]).to eq('Contact file has been processed')
          expect(Contact.where(contact_file_id: processed_contact_file.id).count).to eq(0)
          expect(FailedContact.where(contact_file: processed_contact_file).count).to eq(0)
        end
      end
    end
  end
end
