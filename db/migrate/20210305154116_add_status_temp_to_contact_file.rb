class AddStatusTempToContactFile < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_files, :status_temp, :integer, default: 0
  end
end
