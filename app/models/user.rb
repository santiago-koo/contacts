class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :contacts, class_name: "Contact", foreign_key: "user_id", dependent: :destroy
  has_many :contact_files, class_name: "ContactFile", foreign_key: "user_id", dependent: :destroy
  
end
