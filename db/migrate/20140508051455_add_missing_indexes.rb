class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :purchases, :lesson_id
    add_index :purchases, :student_id
    add_index :lessons, :category_id
    add_index :purchase_accounts, :lesson_id
    add_index :purchase_accounts, :student_id
    add_index :reservations, :lesson_id
    add_index :reservations, :student_id
    add_index :reservations, :purchase_id
    add_index :time_slots, :lesson_id
  end
end
