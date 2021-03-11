require 'rails_helper'

RSpec.feature ContactFile, type: :feature do
  let(:user) { create(:user) }

  scenario 'User is redirected to login page' do
    visit new_contact_file_path
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  context 'a signed in user' do
    before do
      login_as(user, scope: :user)
    end

    let(:filename) { 'contacts.csv' }
    let(:file_path) { "spec/fixtures/#{filename}" }

    scenario 'creates a new contact file' do
      visit new_contact_file_path
      attach_file('contact_file[file]', file_path)
      click_on 'Upload contact file'

      expect(page).to have_content('File loaded successfully')
      expect(page).to have_content(filename)
      expect(page).to have_link('Process csv')
    end
  end
end
