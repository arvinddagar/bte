class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.string :name
      t.integer :user_id, null: false
      t.hstore :properties
      t.integer :time_slots_count, default: 0
      t.integer :weeks_visible, limit: 2, default: 52
      t.integer :green_zone, default: 1440
      t.string :time_zone
      t.timestamps
    end
    add_index :tutors, :user_id, unique: true
    execute 'CREATE INDEX tutors_properties ON tutors USING gin(properties)'
  end
end
