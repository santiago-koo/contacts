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
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  contact_file_id              :bigint
#
class Contact < ApplicationRecord
  include CreditCard

  PHONE_NUMBER_REGEX = /\(([+][0-9]{1,2})\)([ .-]?)([0-9]{3})(\s|-)([0-9]{3})(\s|-)([0-9]{2})(\s|-)([0-9]{2})/.freeze
  NAME_REGEX = /[A-Za-z0-9\-\s]/.freeze

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Invalid email' }, presence: true, uniqueness: { scope: :contact_file_id, message: 'Email already taken' }
  validates :phone_number, format: { with: PHONE_NUMBER_REGEX, message: 'Invalid phone number' }, presence: true
  validates :name, format: { with: NAME_REGEX, message: 'Invalid Name' }, presence: true
  validates :birth_date, presence: true
  validates :address, presence: true
  validates :credit_card, presence: true

  validate :validate_birth_date
  validate :validate_credit_card

  belongs_to :contact_file

  before_save :save_credit_card

  private

  def validate_birth_date
    date = Date.parse(birth_date.to_s)
    date_format = date.strftime('%F')

    errors.add(:birth_date, 'Invalid birth date') unless date_format == birth_date
  rescue Date::Error, TypeError
    errors.add(:birth_date, 'Invalid birth date')
  end

  def validate_credit_card
    self.franchise = detect_franchise
    self.last_four_credt_card_numbers = take_last_four_credit_card_numbers
    errors.add(:credit_card, 'Invalid credit card') if franchise.nil?
  end
end
