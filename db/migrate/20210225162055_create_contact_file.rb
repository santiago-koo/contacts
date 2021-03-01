class CreateContactFile < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_files do |t|
      t.string :name
      t.text :original_headers, array: true, default: []
      t.string :status
      t.references :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end
