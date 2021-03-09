# == Schema Information
#
# Table name: failed_contacts
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
#  contact_file_id               :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'rails_helper'

RSpec.describe FailedContact, type: :model do
  context 'relationships' do
    it { should belong_to :contact_file }
  end

  context 'callbacks' do
    let(:user) { create(:user) }
    let(:contact_file) { create(:contact_file, user_id: user.id) }

    describe 'saving credit card on save' do
      let(:new_failed_contact) { FailedContact.create(credit_card: credit_card, contact_file: contact_file) }

      context 'when credit card number is valid' do
        let(:credit_card) { '4111111111111111' }

        it 'set the franchise with the valid credit card information' do
          expect(new_failed_contact).to have_attributes(
            last_four_credit_card_numbers: credit_card.last(4),
            franchise: 'Visa'
          )
        end
      end

      context 'when credit card number is invalid' do
        let(:credit_card) { '423435345345345' }

        it 'sets the franchise with the invalid credit card information' do
          expect(new_failed_contact).to have_attributes(
            last_four_credit_card_numbers: credit_card.last(4),
            franchise: 'Invalid franchise'
          )
        end
      end

      context 'when credit card number is nil' do
        let(:credit_card) { nil }

        it 'sets both credit card and franchise with invalid information' do
          expect(new_failed_contact).to have_attributes(
            last_four_credit_card_numbers: nil,
            franchise: 'Invalid franchise',
            credit_card: 'Invalid credit card'
          )
        end
      end
    end
  end
end
