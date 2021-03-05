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
class ContactFile < ApplicationRecord
  enum status: { on_hold: 0, processing: 1, finished: 2, failed: 3 }

  has_one_attached :csv_file

  validates :name, presence: true
  validates :original_headers, presence: true
  validates :status, presence: true

  belongs_to :user
  has_many :contacts, dependent: :destroy
  has_many :failed_contacts, dependent: :destroy

  def change_status
    created_contacts = Contact.where(contact_file: self).count
    created_failed_contacts = FailedContact.where(contact_file: self).count

    update(status: :finished) if created_contacts.positive? || created_contacts < created_failed_contacts
    update(status: :failed) if created_contacts.zero? && created_failed_contacts.positive?
  end
end
