class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots, force: true do |t|
      t.integer  'tutor_id'
      t.integer  'lesson_duration'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'starts_at_minutes'
      t.timestamps
    end
    add_index 'time_slots', ['tutor_id'], name: 'index_time_slots_on_tutor_id', using: :btree
  end
end