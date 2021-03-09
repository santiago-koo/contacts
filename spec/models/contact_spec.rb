# == Schema Information
#
# Table name: contacts
#
#  id                            :bigint           not null, primary key
#  email                         :string
#  name                          :string
#  phone_number                  :string
#  birth_date                    :string
#  address                       :string
#  credit_card                   :string
#  last_four_credit_card_numbers :string
#  franchise                     :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  contact_file_id               :bigint
#
require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'relationships' do
    it { should belong_to :contact_file }
  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :phone_number }
    it { should validate_presence_of :name }
    it { should validate_presence_of :birth_date }
    it { should validate_presence_of :address }
    it { should validate_presence_of :credit_card }
    it { should validate_uniqueness_of(:email).scoped_to(:contact_file_id).with_message('Email already taken') }
  end

  context 'custom validations' do
    let(:email) { 'testtest.com' }
    let(:phone_number) { '3193206968' }
    let(:birth_date) { '1995/12/12' }
    let(:credit_card) { '112124234f' }
    let(:new_contact) { Contact.new }

    it 'email is invalid with message' do
      new_contact.email = email
      new_contact.valid?

      expect(new_contact.errors.messages[:email].first).to eq('Invalid email')
    end

    it 'phone number is invalid with message' do
      new_contact.phone_number = phone_number
      new_contact.valid?

      expect(new_contact.errors.messages[:phone_number].first).to eq('Invalid phone number')
    end

    it 'birth date is invalid with message' do
      new_contact.birth_date = birth_date
      new_contact.valid?

      expect(new_contact.errors.messages[:birth_date].first).to eq('Invalid birth date')
    end

    it 'credit card is invalid with message' do
      new_contact.credit_card = credit_card
      new_contact.valid?

      expect(new_contact.errors.messages[:credit_card].first).to eq('Invalid credit card')
    end
  end

  context 'when the given contact information is correct' do
    let(:user) { create(:user) }
    let(:contact_file) { create(:contact_file, user_id: user.id) }
    let(:contact_params) {
      {
        email: 'test@test.com',
        phone_number: '(+00) 000-000-00-00',
        name: 'Pablo',
        birth_date: '1995-12-12',
        address: 'fake street 123',
        credit_card: '4111111111111111',
        contact_file: contact_file
      }
    }

    it 'new contact is valid' do
      new_contact = Contact.new(contact_params)
      expect(new_contact).to be_valid
    end
  end
end
