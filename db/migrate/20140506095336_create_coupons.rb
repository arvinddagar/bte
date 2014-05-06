class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons, force: true do |t|
      t.string  :code
      t.string  :description
      t.date    :start_date
      t.date    :end_date
      t.integer :discount_percentage
      t.boolean  :multiple_use, default: false
      t.timestamps
    end
  end
end