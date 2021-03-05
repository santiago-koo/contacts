class RemoveStatusFromContactFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :contact_files, :status
  end
end
