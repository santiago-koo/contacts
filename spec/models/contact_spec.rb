# == Schema Information
#
# Table name: contacts
#
#  id                           :bigint           not null, primary key
#  email                        :string
#  name                         :string
#  phone_number                 :string
#  birth_date                   :string
#  address                      :string
#  credit_card                  :string
#  last_four_credt_card_numbers :string
#  franchise                    :string
#  user_id                      :bigint
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  contact_file_id              :bigint
#
require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'relationships' do
    it { should belong_to :user }
    it { should belong_to :contact_file }
  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :phone_number }
    it { should validate_presence_of :name }
    it { should validate_presence_of :birth_date }
    it { should validate_presence_of :address }
    it { should validate_presence_of :credit_card }

    it 'email format validation' do
      email = 'testtest.com'
      new_contact = Contact.new(email: email)
      new_contact.valid?

      expect(new_contact.errors.messages[:email].first).to eq('Invalid email')
    end

    it 'phone number format validation' do
      phone_number = '3193206968'
      new_contact = Contact.new(phone_number: phone_number)
      new_contact.valid?

      expect(new_contact.errors.messages[:phone_number].first).to eq('Invalid phone number')
    end

    it 'custom email validation' do
      email = 'test@test.com'
      new_contact = Contact.new(email: email)
      new_contact.save(validate: false)

      new_contact2 = Contact.new(email: email)
      new_contact2.valid?

      expect(new_contact2.errors.messages[:email].first).to eq('Email already taken')
      expect(Contact.count).to eq(1)
    end

    it 'custom birth date validation' do
      birth_date = '1995/12/12'
      new_contact = Contact.new(birth_date: birth_date)
      new_contact.valid?

      expect(new_contact.errors.messages[:birth_date].first).to eq('Invalid birth date')
    end

    it 'custom credit card validation' do
      credit_card = '112124234f'
      new_contact = Contact.new(credit_card: credit_card)
      new_contact.valid?

      expect(new_contact.errors.messages[:credit_card].first).to eq('Invalid credit card')
    end
  end

  context 'callbacks' do
    let(:user) { create(:user) }
    let(:contact_file) { create(:contact_file, user_id: user.id) }

    it '' do
      contact_params = {
        email: 'test@test.com',
        phone_number: '(+00) 000-000-00-00',
        name: 'Pablo',
        birth_date: '1995-12-12',
        address: 'fake street 123',
        credit_card: '4111111111111111',
        user: user,
        contact_file: contact_file,
      }
      new_contact = Contact.new(contact_params)
      new_contact.save

      expect(new_contact.franchise).to eq('Visa')
      expect(new_contact.last_four_credt_card_numbers).to eq(contact_params[:credit_card].last(4))
      expect(new_contact.credit_card).to eq(Digest::SHA2.hexdigest(contact_params[:credit_card]))
    end
  end
end
