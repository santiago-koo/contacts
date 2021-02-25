module Validations
  class ContactDetails
    include ActiveModel::Validations

    attr_accessor :name, :birth_date, :phone_number, :address, :credit_card, :email, :franchise

    validate :validate_birth_date
    validate :validate_credit_card

    def validate_birth_date
      begin
        date = Date.parse(@birth_date.to_s)
        date_format = date.strftime("%F")

        errors.add(:birth_date, 'Birth date invalid') unless date_format == @birth_date
      rescue => e
        errors.add(:birth_date, 'Birth date invalid')
      end
    end

    def validate_credit_card
      detector = CreditCardDetector::Detector.new(credit_card)
      @franchise = detector.brand_name
      
      errors.add(:credit_card, 'Credit card invalid') if @franchise.nil?
    end
    
  end
end