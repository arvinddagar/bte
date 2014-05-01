class CreatePurchaseAccounts < ActiveRecord::Migration
  def change
    create_table :purchase_accounts do |t|
      t.integer  'tutor_id'
      t.integer  'student_id'
      t.integer  'free_tokens'
      t.integer  'comped_tokens'
      t.integer  'paid_tokens',   default: 0
      t.integer  'trial_tokens'
      t.timestamps
    end
    add_index 'purchase_accounts', ['student_id', 'tutor_id'], name: 'index_purchase_accounts_on_student_id_and_tutor_id'
  end
end
