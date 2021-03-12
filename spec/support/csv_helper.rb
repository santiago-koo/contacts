module CsvHelper
  def normalize_csv_file(file_path)
    # Detect file encoding
    detection = CharlockHolmes::EncodingDetector.detect(File.read(file_path))
    encoding = detection[:encoding] == 'UTF-8' ? detection[:encoding].downcase : "#{detection[:encoding].downcase}:utf-8"
    # Read file and transform encoding to UTF-8
    file_content = File.open(file_path, "r:#{encoding}", &:read)
    # Replace semicolon separator for comma
    file_content.gsub(';', ',')
  end

  def attach_content(contact_file, file_path, filename)
    file_content = normalize_csv_file(file_path)
    contact_file.csv_file.attach({ io: StringIO.new(file_content), filename: filename })
  end
end
