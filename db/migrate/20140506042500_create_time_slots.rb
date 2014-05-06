class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots, force: true do |t|
      t.integer  :lesson_id, index: true
      t.integer  :lesson_duration
      t.integer  :starts_at_minutes
      t.timestamps
    end
  end
end