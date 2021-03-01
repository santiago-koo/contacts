require 'csv'

class ManageContactsCsv
  
  def initialize(params={})
    @headers = params[:headers] || {}
    @contact_file = params[:contact_file]
    @user = params[:user]
  end

  def call
    begin
      @contact_file.update(status: :processing)
      csv_file_content = @contact_file.csv_file.download
      headers = ::CSV.parse(csv_file_content).first

      ::CSV.parse(csv_file_content, converters: nil, headers: true) do |row|
        email = row[@headers[:email]]
        name = row[@headers[:name]]
        birth_date = row[@headers[:birth_date]]
        phone_number = row[@headers[:phone_number]]
        address = row[@headers[:address]]
        credit_card = row[@headers[:credit_card]]

        new_contact = Contact.new(email: email, name: name, birth_date: birth_date, phone_number: phone_number, address: address, credit_card: credit_card, last_four_credt_card_numbers: credit_card.last(4), user: @user, contact_file: @contact_file)
        
        if new_contact.valid?
          new_contact.save
        else
          # return_message(false, {errors: new_contact.errors.messages})
        end
        
      end

      return_message(true, {})
    rescue => e
      @contact_file.update(status: :failed)
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      return_message(false, {})
    end
  end

  private

  def return_message(success, payload={})
    OpenStruct.new({success?: success, payload: payload})
  end

end