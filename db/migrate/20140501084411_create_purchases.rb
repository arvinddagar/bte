class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer  :lesson_id, index: true
      t.integer  :student_id, index: true
      t.string   :stripe_charge_id
      t.string   :description
      t.string   :payment_method
      t.integer  :lessons_purchased, default: 0
      t.decimal  :amount, precision: 7, scale: 2
      t.integer  :original_lessons_purchased
      t.integer  :coupon_id
      t.decimal  :original_amount, precision: 7, scale: 2
      t.integer  :discounter_id, index: true
      t.timestamps
    end
  end
end
