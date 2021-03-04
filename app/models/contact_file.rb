# == Schema Information
#
# Table name: contact_files
#
#  id               :bigint           not null, primary key
#  name             :string
#  original_headers :text             default([]), is an Array
#  status           :string
#  user_id          :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class ContactFile < ApplicationRecord
  # enum status: %i[on_hold processing finished]

  has_one_attached :csv_file

  validates :name, presence: true
  validates :original_headers, presence: true
  validates :status, presence: true

  belongs_to :user
  has_many :contacts, dependent: :destroy
  has_many :failed_contacts, dependent: :destroy
end
