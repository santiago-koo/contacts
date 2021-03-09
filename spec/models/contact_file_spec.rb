# == Schema Information
#
# Table name: contact_files
#
#  id               :bigint           not null, primary key
#  name             :string
#  original_headers :text             default([]), is an Array
#  user_id          :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  status           :integer          default("on_hold")
#
require 'rails_helper'

RSpec.describe ContactFile, type: :model do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :original_headers }
    it { should validate_presence_of :status }
  end

  context 'relationships' do
    it { should belong_to :user }
    it { should have_many(:contacts) }
    it { should have_many(:failed_contacts) }
  end

  context 'csv_file storage' do
    it 'download csv_file content' do
      file = Rails.root.join('spec', 'fixtures', 'contacts.csv')
      csv_file = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file, 'rb'),
        filename: 'contacts.csv',
        content_type: 'text/csv'
      ).signed_id

      contact_file_item = ContactFile.new(csv_file: csv_file)
      expect(contact_file_item.csv_file.download).to eq(IO.read(file))
    end
  end
end
