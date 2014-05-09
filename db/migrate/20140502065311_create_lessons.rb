class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.text :description
      t.references :tutor, index: true
      t.string :slug, unique: true, index: true
      t.string :address
      t.float :latitude
      t.float :longitude
      t.decimal :amount, precision: 7, scale: 2
      t.string :phone_number
      t.integer :level, default: 0
      t.integer :green_zone, default: 1440
      t.integer :weeks_visible, default: 1
      t.integer :allowed_people
      t.integer  :lesson_duration, default: 30, null: false
      t.integer  :time_slots_count, default: 0
      t.timestamps
    end
  end
end
