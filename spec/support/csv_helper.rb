module CsvHelper
  def normalize_csv_file(file_path)
    # Detect file encoding
    detection = CharlockHolmes::EncodingDetector.detect(File.read(file_path))
    encoding = detection[:encoding] == 'UTF-8' ? detection[:encoding].downcase : "#{detection[:encoding].downcase}:utf-8"
    # Read file and transform encoding to UTF-8
    file_content = File.open(file_path, "r:#{encoding}"){ |f| f.read }
    # Replace semicolon separator for comma
    file_content.gsub(';', ',')
  end
end
