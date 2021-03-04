# == Schema Information
#
# Table name: failed_contacts
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
#  contact_file_id              :bigint
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
require 'rails_helper'

RSpec.describe FailedContact, type: :model do
  context 'relationships' do
    it { should belong_to :contact_file }
  end

  context 'callbacks' do
    let(:user) { create(:user) }
    let(:contact_file) { create(:contact_file, user_id: user.id) }

    it 'set franchise with a valid credit card' do
      credit_card = '4111111111111111'
      new_failed_contact = FailedContact.create(credit_card: credit_card, contact_file: contact_file)

      expect(new_failed_contact.last_four_credt_card_numbers).to eq(credit_card.last(4))
      expect(new_failed_contact.franchise).to eq('Visa')
    end

    it 'set franchise with an invalid credit card' do
      credit_card = '423435345345345'
      new_failed_contact = FailedContact.create(credit_card: credit_card, contact_file: contact_file)

      expect(new_failed_contact.last_four_credt_card_numbers).to eq(credit_card.last(4))
      expect(new_failed_contact.franchise).to eq('Invalid franchise')
    end

    it 'credit card as nil' do
      credit_card = nil
      new_failed_contact = FailedContact.create(credit_card: credit_card, contact_file: contact_file)

      expect(new_failed_contact.last_four_credt_card_numbers).to eq(nil)
      expect(new_failed_contact.franchise).to eq('Invalid franchise')
      expect(new_failed_contact.credit_card).to eq('Invalid credit card')
    end
  end
end
