require 'rails_helper'

RSpec.describe ManageContactsCsv do
  let(:user) { create(:user) }
  let(:contact_file) { create(:contact_file, user_id: user.id) }

  context 'call' do
    it 'upload csv - finished with contacts and failed contacts' do
      filename = 'contacts.csv'
      file_path = "spec/fixtures/#{filename}"
      file_content = normalize_csv_file(file_path)

      contact_file.csv_file.attach({ io: StringIO.new(file_content), filename: filename })

      headers = {
        email: 'email',
        name: 'nombre',
        birth_date: 'fecha_de_nacimiento',
        phone_number: 'telefono',
        address: 'direccion',
        credit_card: 'tarjeta_de_credito'
      }

      result = ::ManageContactsCsv.new({ headers: headers, contact_file: contact_file }).call
      expect(result.success?).to eq(true)
      expect(contact_file.status).to eq('finished')
      expect(Contact.where(contact_file: contact_file).count).to eq(2)
      expect(FailedContact.where(contact_file: contact_file).count).to eq(2)
    end

    it 'upload csv - failed without contacts neither failed contacts' do
      filename = 'contacts.csv'
      file_path = "spec/fixtures/#{filename}"
      file_content = normalize_csv_file(file_path)

      contact_file.csv_file.attach({ io: StringIO.new(file_content), filename: filename })

      headers = :nil

      result = ::ManageContactsCsv.new({ headers: headers, contact_file: contact_file }).call
      expect(result.success?).to eq(false)
      expect(contact_file.status).to eq('failed')
      expect(Contact.where(contact_file: contact_file).count).to eq(0)
      expect(FailedContact.where(contact_file: contact_file).count).to eq(0)
    end

    it 'upload csv - failed with failed contacts' do
      filename = 'contacts.csv'
      file_path = "spec/fixtures/#{filename}"
      file_content = normalize_csv_file(file_path)

      contact_file.csv_file.attach({ io: StringIO.new(file_content), filename: filename })

      headers = {
        email: 'email',
        name: 'name',
        birth_date: 'birth_date',
        phone_number: 'phone_number',
        address: 'address',
        credit_card: 'credit_card'
      }

      result = ::ManageContactsCsv.new({ headers: headers, contact_file: contact_file }).call
      expect(result.success?).to eq(true)
      expect(contact_file.status).to eq('failed')
      expect(FailedContact.where(contact_file: contact_file).count).to eq(4)
    end

    it 'do not allow process already processed contact files' do
      processed_contact_file = ContactFile.new(status: :finished)
      processed_contact_file.save(validate: false)

      result = ::ManageContactsCsv.new({ headers: {}, contact_file: processed_contact_file }).call
      expect(result.success?).to eq(false)
      expect(result.payload[:error]).to eq('Contact file has been processed')
      expect(Contact.where(contact_file_id: processed_contact_file.id).count).to eq(0)
    end
  end
end
