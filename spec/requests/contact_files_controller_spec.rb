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

  context 'when user has signed in' do
    before { login_as(user, scope: :user) }

    describe 'GET index' do
      context 'the user has at least one contact file' do
        let(:contact_file) { create(:contact_file, user: user) }

        it 'should include the contact_file name in the body' do
          contact_file

          get root_path
          expect(response).to have_http_status(200)
          expect(response.body).to include contact_file.name
        end
      end

      context 'the user has not any contact file' do
        it "should include 'There are not contact files yet' in the body" do
          get root_path
          expect(response).to have_http_status(200)
          expect(response.body).to include 'There are not contact files yet'
        end
      end
    end

    describe 'GET show' do
      context 'when the contact file has not been processed' do
        let(:contact_file) { create(:contact_file, user: user) }

        it 'should redirect to contact_files page' do
          get contact_file_path(contact_file.id)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to 'http://www.example.com/contact_files'
        end
      end

      context 'when the contact file has been processed' do
        let(:contact_file) { create(:contact_file_with_contacts, :finished, contacts_count: 2, user: user) }

        it 'should shows all contacts related to' do
          get contact_file_path(contact_file.id)
          expect(response).to have_http_status(200)
          expect(response.body).to include(contact_file.contacts.first.name)
          expect(response.body).to include(contact_file.contacts.last.name)
        end
      end

      context 'when the contact file does not exists' do
        let(:contact_file) { 10_000 }

        it 'should redirect to 404' do
          get contact_file_path(contact_file)
          expect(response).to have_http_status(404)
        end
      end
    end

    describe 'POST create' do
      context 'when a signed in user goes to create a new contact file' do
        let(:file_path) { 'spec/fixtures/contacts.csv' }

        context 'with correct params' do
          let(:contact_file_params) { { contact_file: { file: Rack::Test::UploadedFile.new(file_path, 'text/csv') } } }
          let(:manage_contact_files_instance) { instance_double(ManageContactFile) }

          it 'sets success? equals true' do
            allow(manage_contact_files_instance).to receive(:call) { double(success?: true) }
            expect(ManageContactFile).to receive(:new).with(
              file_path: instance_of(String),
              user: user,
              filename: instance_of(String)
            ).and_return(manage_contact_files_instance)

            post contact_files_path, params: contact_file_params
            expect(response).to have_http_status(302)
            expect(flash[:notice]).to eq('File loaded successfully')
          end

          it 'sets success? equals false' do
            allow(manage_contact_files_instance).to receive(:call) { double(success?: false, payload: {}) }
            expect(ManageContactFile).to receive(:new).with(
              file_path: instance_of(String),
              user: user,
              filename: instance_of(String)
            ).and_return(manage_contact_files_instance)

            post contact_files_path, params: contact_file_params
            expect(response).to have_http_status(302)
          end
        end

        context 'without contact_file param' do
          let(:contact_file_params) { {} }

          it 'should redirect to index page if contact_file param is not present' do
            post contact_files_path params: contact_file_params
            expect(response).to have_http_status(302)
            expect(user.contact_files.count).to be_zero
          end
        end
      end
    end

    describe 'GET failed_contacts' do
      context 'when the contact file has been processed with failed contacts' do
        let(:contact_file) do
          create(:contact_file_with_failed_contacts, :finished, failed_contacts_count: 2, user: user)
        end

        it 'should redirect to contact_files page' do
          get failed_contacts_contact_file_path(contact_file.id)
          expect(response).to have_http_status(200)
          expect(response.body).to include(contact_file.failed_contacts.first.name)
          expect(response.body).to include(contact_file.failed_contacts.last.name)
        end
      end
    end

    describe 'GET process_csv' do
      context 'with correct params' do
        let(:process_csv_params) do
          { process_csv: { email: 'email', name: 'nombre', birth_date: 'fecha_de_nacimiento', phone_number: 'telefono',
                           address: 'direccion', credit_card: 'tarjeta_de_credito' } }
        end
        let(:filename) { 'contacts.csv' }
        let(:file_path) { "spec/fixtures/#{filename}" }
        let(:contact_file) { create(:contact_file, user: user) }

        it 'should redirect to index page with a notice flash message and a job enqueued' do
          attach_content(contact_file, file_path, filename)

          expect do
            post process_csv_contact_file_path(contact_file), params: process_csv_params
          end.to have_enqueued_job(ProcessContactFileJob).with(
            { email: 'email', name: 'nombre', birth_date: 'fecha_de_nacimiento', phone_number: 'telefono',
              address: 'direccion', credit_card: 'tarjeta_de_credito' }, contact_file.id
          )

          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('CSV file is being processed. Lay on your couch and take an orange juice')
        end
      end
    end
  end
end
