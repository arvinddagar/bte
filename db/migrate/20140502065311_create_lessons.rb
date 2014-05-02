class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :description
      t.references :tutor, index: true
      t.string :slug, unique: true, index: true
      t.string :location
      t.string :lat
      t.string :long
      t.decimal :amount, precision: 7, scale: 2
      t.string :phone_number
      t.integer :level, default: 0
      t.integer :weeks_visible, default: 52
      t.date :start_date
      t.integer :allowed_people
      t.date :end_date
      t.timestamps
    end
  end
end
