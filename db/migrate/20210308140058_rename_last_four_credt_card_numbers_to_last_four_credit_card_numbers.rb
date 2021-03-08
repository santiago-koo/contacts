class RenameLastFourCredtCardNumbersToLastFourCreditCardNumbers < ActiveRecord::Migration[6.1]
  def change
    rename_column :contacts, :last_four_credt_card_numbers, :last_four_credit_card_numbers
    rename_column :failed_contacts, :last_four_credt_card_numbers, :last_four_credit_card_numbers
  end
end
