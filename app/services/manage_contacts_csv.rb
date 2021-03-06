require 'csv'

class ManageContactsCsv
  include ApplicationService

  def initialize(params = {})
    @headers = params[:headers] || {}
    @contact_file = params[:contact_file]
    @headers.try(:transform_keys!, &:to_sym)
  end

  def call
    return return_message(false, { error: 'Contact file has been processed' }) unless @contact_file.on_hold?

    @contact_file.processing!
    create_contacts_from_csv
    @contact_file.change_status

    return_message(true, {})
  rescue StandardError => e
    @contact_file.failed!
    log_errors(e)
  end

  private

  def create_contacts_from_csv
    csv_file_content = @contact_file.csv_file.download

    ::CSV.parse(csv_file_content, converters: nil, headers: true) do |row|
      new_contact = Contact.new(
        email: row[@headers[:email]],
        name: row[@headers[:name]],
        birth_date: row[@headers[:birth_date]],
        phone_number: row[@headers[:phone_number]],
        address: row[@headers[:address]],
        credit_card: row[@headers[:credit_card]],
        contact_file: @contact_file
      )

      if new_contact.save
        # empty
      else
        create_failed_contact(new_contact)
      end
    end
  end

  def create_failed_contact(new_contact)
    failed_contact_params = {}
    new_contact.attributes.each do |contact_attribute, value|
      new_contact_error_messages = new_contact.errors.messages[contact_attribute.to_sym]

      failed_contact_params[contact_attribute.to_sym] =
        if new_contact_error_messages.blank?
          value
        else
          new_contact_error_messages.sort.join(' - ')
        end
    end

    FailedContact.create(failed_contact_params.merge({ contact_file: @contact_file }))
  end
end
