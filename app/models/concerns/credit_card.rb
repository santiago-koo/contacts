module CreditCard
  extend ActiveSupport::Concern

  def save_credit_card
    self.franchise = detect_franchise || 'Invalid franchise'
    self.last_four_credit_card_numbers = take_last_four_credit_card_numbers
    self.credit_card = encrypt_credit_card || 'Invalid credit card'
  end

  def encrypt_credit_card
    Digest::SHA2.hexdigest(credit_card)
  rescue TypeError
    credit_card
  end

  def take_last_four_credit_card_numbers
    credit_card.try(:last, 4)
  end

  def detect_franchise
    detector = CreditCardDetector::Detector.new(credit_card)
    detector.brand_name
  end
end
