require 'rails_helper'

RSpec.describe ManageContactFile do
  let(:user) { create(:user) }

  describe '#call' do
    context 'upload a csv file' do
      let(:file_path) { "spec/fixtures/#{filename}" }
      let(:result) { ::ManageContactFile.new({ file_path: file_path, user: user, filename: filename }).call }

      context 'when the csv filename is correct' do
        let(:filename) { 'contacts.csv' }

        it 'a contact file is created' do
          expect(result.success?).to eq(true)
          expect(ContactFile.count).to eq(1)
        end
      end

      context 'when the csv filename is incorrect' do
        let(:filename) { 'non_existent.csv' }

        it 'no contact file is created' do
          expect(result.success?).to eq(false)
          expect(ContactFile.count).to eq(0)
        end
      end

      context 'a context' do
        let(:filename) { 'contacts_without_content.csv' }

        it 'no contact file is created and raise an error' do
          expect(result.success?).to eq(false)
          expect(result.payload[:errors][:original_headers]).to include("can't be blank")
          expect(ContactFile.count).to eq(0)
        end
      end
    end
  end
end
