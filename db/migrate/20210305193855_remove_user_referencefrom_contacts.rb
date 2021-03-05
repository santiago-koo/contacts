class RemoveUserReferencefromContacts < ActiveRecord::Migration[6.1]
  def change
    remove_column :contacts, :user_id
  end
end
