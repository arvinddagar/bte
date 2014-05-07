class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :lesson_id, index: true
      t.integer :student_id, index: true
      t.integer :purchase_id, index: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.string   :reservation_type # :paid, :comped, :package
      t.string   :state # :completed, :reserved
      t.integer  :discounter_id
      t.timestamps
    end
  end
end