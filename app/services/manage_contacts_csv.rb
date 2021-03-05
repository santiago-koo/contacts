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
      create_contact_from_csv
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

  def create_contact_from_csv
    csv_file_content = @contact_file.csv_file.download

    ::CSV.parse(csv_file_content, converters: nil, headers: true) do |row|
      new_contact = Contact.new(
        email: row[@headers[:email]],
        name: row[@headers[:name]],
        birth_date: row[@headers[:birth_date]],
        phone_number: row[@headers[:phone_number]],
        address: row[@headers[:address]],
        credit_card: row[@headers[:credit_card]],
        user: @user,
        contact_file: @contact_file
      )

      create_failed_contact(new_contact) unless new_contact.save
    end
  end

  def update_contact_file_status
    created_contacts = Contact.where(contact_file: @contact_file).count
    created_failed_contacts = FailedContact.where(contact_file: @contact_file).count

    @contact_file.update(status: :finished) if created_contacts.positive? || created_contacts < created_failed_contacts
    @contact_file.update(status: :failed) if created_contacts.zero? && created_failed_contacts.positive?
  end

  def create_failed_contact(new_contact)
    failed_contact_params = {}

    new_contact.attributes.each do |contact_attribute, value|
      new_contact_error_messages = new_contact.errors.messages[contact_attribute.to_sym]

      failed_contact_params[contact_attribute.to_sym] = if new_contact_error_messages.blank?
                                                          value
                                                        else
                                                          new_contact_error_messages.sort.join(' - ')
                                                        end
    end

    FailedContact.create(failed_contact_params, contact_file: @contact_file)
  end

  def return_message(success, payload = {})
    OpenStruct.new({ success?: success, payload: payload })
  end
end
