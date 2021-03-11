require 'rails_helper'

RSpec.describe ContactFilesController, type: :request do
  let(:user) { create(:user) }

  context 'when user are not signed in' do
    it 'should redirects to sign_in page' do
      get root_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to 'http://www.example.com/users/sign_in'
    end
  end

  describe 'GET index' do
    context 'when user has signed in' do
      context 'and the user has at least one contact file' do
        let(:contact_file) { create(:contact_file, user: user) }

        it 'should include the contact_file name in the body' do
          login_as(user, scope: :user)
          contact_file

          get root_path
          expect(response).to have_http_status(200)
          expect(response.body).to include contact_file.name
        end
      end

      context 'and the user has not any contact file' do
        it "should include 'There are not contact files yet' in the body" do
          login_as(user, scope: :user)

          get root_path
          expect(response).to have_http_status(200)
          expect(response.body).to include 'There are not contact files yet'
        end
      end
    end
  end

  describe 'GET show' do
    context 'when the contact file has not been processed' do
      let(:contact_file) { create(:contact_file, user: user) }

      it 'should redirect to contact_files page' do
        login_as(user, scope: :user)

        get contact_file_path(contact_file.id)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to 'http://www.example.com/contact_files'
      end
    end

    context 'when the contact file has been processed' do
      let(:contact_file) { create(:contact_file, :finished, user: user) }

      it 'should shows all contacts related to' do
        login_as(user, scope: :user)

        get contact_file_path(contact_file.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when the contact file does not exists' do
      let(:contact_file) { 10_000 }

      it 'should redirect to 404' do
        login_as(user, scope: :user)

        get contact_file_path(contact_file)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET new' do
    context 'when a signed in user is about to create new contact file' do
      it 'should redirect it to new contact file page' do
        login_as(user, scope: :user)

        get new_contact_file_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET create' do
    context 'when a signed in user goes to create a new contact file' do
      let(:filename) { 'contacts.csv' }
      let(:file_path) { "spec/fixtures/#{filename}" }
      let(:contact_files_count) { ContactFile.count }

      context 'with correct params' do
        let(:contact_file_params) { { contact_file: { file: Rack::Test::UploadedFile.new(file_path, 'text/csv') } } }

        it 'should redirect to index page with a notice flash message' do
          login_as(user, scope: :user)

          post contact_files_path, params: contact_file_params
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('File loaded successfully')
          expect(contact_files_count).to be == 1
        end
      end

      context 'without contact_file param' do
        let(:contact_file_params) { { contact_file: nil } }

        it 'should redirect to index page if contact_file param is not present' do
          login_as(user, scope: :user)

          post contact_files_path params: contact_file_params
          expect(response).to have_http_status(302)
          expect(contact_files_count).to be == 0
        end
      end
    end
  end

  describe 'GET failed_contacts' do
    context 'when the contact file has been processed with failed contacts' do
      let(:contact_file) { create(:contact_file, :finished, user: user) }

      it 'should redirect to contact_files page' do
        login_as(user, scope: :user)

        get failed_contacts_contact_file_path(contact_file.id)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET process_csv' do
    context 'with correct params' do
      let(:process_csv_params) { { process_csv: { email: 'test@test.com', name: 'Santiago', birth_date: '1995-11-29', phone_number: '(+00) 000 000 00 00', address: 'fake street 123', credit_card: '30569309025904' } } }
      let(:contact_file) { create(:contact_file, user: user) }

      it 'should redirect to index page with a notice flash message' do
        Sidekiq::Testing.inline!
        login_as(user, scope: :user)

        post process_csv_contact_file_path(contact_file), params: process_csv_params
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('CSV file is being processed. Lay on your couch and take an orange juice')
      end
    end
  end
end
