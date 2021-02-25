class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :name
      t.string :phone_number
      t.string :birth_date
      t.string :address
      t.string :credit_card
      t.string :last_four_credt_card_numbers
      t.string :franchise

      t.references :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end
