class FailedContact < ApplicationRecord

  belongs_to :contact_file, class_name: "ContactFile", foreign_key: "contact_file_id"

  before_create :get_franchise
  before_create :encrypt_credit_card

  private

  def get_franchise
    detector = CreditCardDetector::Detector.new(self.credit_card)
    self.franchise = detector.brand_name
  end
  
  def encrypt_credit_card
    begin
      self.last_four_credt_card_numbers = self.credit_card.try(:last, 4)
      self.credit_card = Digest::SHA2.hexdigest(self.credit_card)
    rescue => e
      self.last_four_credt_card_numbers = "Invalid franchise"
      self.credit_card = ""
    end
  end

end
