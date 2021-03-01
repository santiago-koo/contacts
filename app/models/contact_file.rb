class ContactFile < ApplicationRecord

  has_one_attached :csv_file
  
  validates :name, presence: true
  validates :original_headers, presence: true
  validates :status, presence: true

  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :contacts, class_name: "Contact", foreign_key: "contact_file_id", dependent: :destroy

end
