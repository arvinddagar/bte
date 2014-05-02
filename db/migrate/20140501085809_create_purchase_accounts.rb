class CreatePurchaseAccounts < ActiveRecord::Migration
  def change
    create_table :purchase_accounts do |t|
      t.timestamps
    end
  end
end
