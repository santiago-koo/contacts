class AddContactFileReferenceToContacts < ActiveRecord::Migration[6.1]
  def change
    add_reference :contacts, :contact_file, index: true
  end
end
