require 'rails_helper'

RSpec.describe Contact, type: :feature do
  let(:user) { create(:user) }

  context 'a signed in user' do
    before do
      Sidekiq::Testing.inline!
      login_as(user, scope: :user)
    end

    let(:filename) { 'contacts.csv' }
    let(:file_path) { "spec/fixtures/#{filename}" }

    scenario 'process a contact file', js: true do
      visit new_contact_file_path
      attach_file('contact_file[file]', file_path)
      click_on 'Upload contact file'

      click_on 'Process csv'
      expect(page).to have_content("Process #{user.contact_files.take.name}")

      within '#process_csv_email' do
        find("option[value='email']").click
      end
      within '#process_csv_name' do
        find("option[value='nombre']").click
      end
      within '#process_csv_birth_date' do
        find("option[value='fecha_de_nacimiento']").click
      end
      within '#process_csv_phone_number' do
        find("option[value='telefono']").click
      end
      within '#process_csv_address' do
        find("option[value='direccion']").click
      end
      within '#process_csv_credit_card' do
        find("option[value='tarjeta_de_credito']").click
      end

      click_on 'Upload contact file'
      expect(page).to have_content('CSV file is being processed. Lay on your couch and take an orange juice')
    end
  end
end
