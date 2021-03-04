require 'csv'

class ManageContactFile
  def initialize(params = {})
    @csv_file_path = params[:file_path]
    @user = params[:user]
    @filename = params[:filename]
  end

  def call
    normalized_file_content = normalize_csv_file
    create_contact_file(normalized_file_content)
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    return_message(false, { error: e.message })
  end

  private

  def normalize_csv_file
    # Detect file encoding
    detection = CharlockHolmes::EncodingDetector.detect(File.read(@csv_file_path))
    encoding = detection[:encoding] == 'UTF-8' ? detection[:encoding].downcase : "#{detection[:encoding].downcase}:utf-8"
    # Read file and transform encoding to UTF-8
    file_content = File.open(@csv_file_path, "r:#{encoding}"){ |f| f.read }
    # Replace semicolon separator for comma
    file_content.gsub(';', ',')
  end

  def create_contact_file(normalized_file_content)
    headers = ::CSV.parse(normalized_file_content).first
    contact_file = ContactFile.new(name: @filename, original_headers: headers, status: :on_hold, user: @user)

    if contact_file.save
      contact_file.csv_file.attach({ io: StringIO.new(normalized_file_content), filename: @filename })
      return_message(true, { contact_file: contact_file })
    else
      return_message(false, { errors: contact_file.errors.messages })
    end
  end

  def return_message(success, payload={})
    OpenStruct.new({success?: success, payload: payload})
  end
end
