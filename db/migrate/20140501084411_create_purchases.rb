class CreatePurchases < ActiveRecord::Migration
  def change
    create_table 'purchases', force: true do |t|
      t.integer  'tutor_id'
      t.integer  'student_id'
      t.string   'stripe_charge_id'
      t.text     'description'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer  'lessons_purchased',                                        default: 0
      t.decimal  'amount',                     precision: 7, scale: 2
    end
    add_index :purchases, :student_id
    add_index :purchases, :tutor_id
  end
end
