class CreatePurchaseAccounts < ActiveRecord::Migration
  def change
    create_table :purchase_accounts do |t|
      t.integer  :lesson_id, index: true
      t.integer  :student_id
      t.integer  :free_tokens,   default: 0
      t.integer  :comped_tokens,   default: 0
      t.integer  :paid_tokens,   default: 0
      t.integer  :trial_tokens,   default: 0
      t.timestamps
    end
  end
end