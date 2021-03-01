class Contact < ApplicationRecord
  
  PHONE_NUMBER_REGEX = /\(([+][0-9]{1,2})\)([ .-]?)([0-9]{3})(\s|[-])([0-9]{3})(\s|[-])([0-9]{2})(\s|[-])([0-9]{2})/
  NAME_REGEX = /[A-Za-z0-9\-\s]/

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email invalid" }, presence: true
  validates :phone_number, format: { with: PHONE_NUMBER_REGEX, message: "Phone number invalid" }, presence: true
  validates :name, format: { with: NAME_REGEX, message: "Name invalid" }, presence: true
  validates :birth_date, presence: true
  validates :address, presence: true
  validates :credit_card, presence: true

  validate :check_uniqueness_email
  validate :validate_birth_date
  validate :validate_credit_card

  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :contact_file, class_name: "ContactFile", foreign_key: "contact_file_id"

  before_save :encrypt_credit_card

  private

  def check_uniqueness_email
    repeated_email = Contact.where(contact_file: self.contact_file, email: self.email).last
    errors.add(:email, 'Repeated email') unless repeated_email.nil?
  end

  def encrypt_credit_card
    begin
      self.last_four_credt_card_numbers = self.credit_card.try(:last, 4)
      self.credit_card = Digest::SHA2.hexdigest(self.credit_card)
    rescue => e
      self.last_four_credt_card_numbers = ""
      self.credit_card = ""
    end
  end  

  def validate_birth_date
    begin
      date = Date.parse(self.birth_date.to_s)
      date_format = date.strftime("%F")

      errors.add(:birth_date, 'Birth date invalid') unless date_format == self.birth_date
    rescue => e
      errors.add(:birth_date, 'Birth date invalid')
    end
  end

  def validate_credit_card
    detector = CreditCardDetector::Detector.new(credit_card)
    self.franchise = detector.brand_name
    
    errors.add(:credit_card, 'Credit card invalid') if self.franchise.nil?
  end

end
