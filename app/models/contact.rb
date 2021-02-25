class Contact < ApplicationRecord
  
  PHONE_NUMBER_REGEX = /\(([+][0-9]{1,2})\)([ .-]?)([0-9]{3})(\s|[-])([0-9]{3})(\s|[-])([0-9]{2})(\s|[-])([0-9]{2})/
  NAME_REGEX = /[A-Za-z0-9\-\s]/

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email invalid" }, presence: true, uniqueness: true
  validates :phone_number, format: { with: PHONE_NUMBER_REGEX, message: "Phone number invalid" }, presence: true
  validates :name, format: { with: NAME_REGEX, message: "Name invalid" }, presence: true
  validates :birth_date, presence: true
  validates :address, presence: true
  validates :credit_card, presence: true

  belongs_to :user, class_name: "User", foreign_key: "user_id"

end
