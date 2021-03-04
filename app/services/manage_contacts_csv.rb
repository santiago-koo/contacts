require 'csv'

class ManageContactsCsv
  def initialize(params = {})
    @headers = params[:headers] || {}
    @contact_file = params[:contact_file]
    @user = params[:user]
  end

  def call
    return return_message(false, { error: 'Contact file has been processed' }) if @contact_file.status != 'on_hold'

    begin
      @contact_file.update(status: :processing)
      csv_file_content = @contact_file.csv_file.download

      ::CSV.parse(csv_file_content, converters: nil, headers: true) do |row|
        email = row[@headers[:email]]
        name = row[@headers[:name]]
        birth_date = row[@headers[:birth_date]]
        phone_number = row[@headers[:phone_number]]
        address = row[@headers[:address]]
        credit_card = row[@headers[:credit_card]]

        new_contact = Contact.new(email: email, name: name, birth_date: birth_date, phone_number: phone_number, address: address, credit_card: credit_card, user: @user, contact_file: @contact_file)

        create_failed_contact(new_contact) unless new_contact.save
      end

      update_contact_file_status

      return_message(true, {})
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      @contact_file.update(status: :failed)
      return_message(false, {})
    end
  end

  private

  def update_contact_file_status
    created_contacts = Contact.where(contact_file: @contact_file).count
    created_failed_contacts = FailedContact.where(contact_file: @contact_file).count

    @contact_file.update(status: :finished) if created_contacts.positive? || created_contacts < created_failed_contacts
    @contact_file.update(status: :failed) if created_contacts.zero? && created_failed_contacts.positive?
  end

  def create_failed_contact(new_contact)
    FailedContact.create(
      email: new_contact.errors.messages[:email].empty? ? new_contact.email : new_contact.errors.messages[:email].sort.join(' - '),
      name: new_contact.errors.messages[:name].empty? ? new_contact.name : new_contact.errors.messages[:name].sort.join(' - '),
      birth_date: new_contact.errors.messages[:birth_date].empty? ? new_contact.birth_date : new_contact.errors.messages[:birth_date].sort.join(' - '),
      phone_number: new_contact.errors.messages[:phone_number].empty? ? new_contact.phone_number : new_contact.errors.messages[:phone_number].sort.join(' - '),
      address: new_contact.errors.messages[:address].empty? ? new_contact.address : new_contact.errors.messages[:address].sort.join(' - '),
      credit_card: new_contact.errors.messages[:credit_card].empty? ? new_contact.credit_card : new_contact.errors.messages[:credit_card].sort.join(' - '),
      contact_file: @contact_file
    )
  end

  def return_message(success, payload = {})
    OpenStruct.new({ success?: success, payload: payload })
  end
end
