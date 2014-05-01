class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.string :name
      t.string :slug
      t.integer :user_id, null: false
      t.hstore :properties
      t.integer :time_slots_count, default: 0
      t.integer :weeks_visible, limit: 2, default: 52
      t.integer :green_zone, default: 1440
      t.string :time_zone
      t.integer :lesson_duration, null: false, default: 30
      t.timestamps
    end
    add_index :tutors, :user_id, unique: true
    add_index :tutors, :slug, unique: true
    execute 'CREATE INDEX tutors_properties ON tutors USING gin(properties)'
  end
end
