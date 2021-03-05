class RenameStatusTempToStatus < ActiveRecord::Migration[6.1]
  def change
    rename_column :contact_files, :status_temp, :status
  end
end
