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
class FailedContact < ApplicationRecord
  include CreditCard

  belongs_to :contact_file

  before_create :save_credit_card
end
