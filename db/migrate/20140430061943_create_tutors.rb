class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.string :name
      t.string :slug
      t.integer :user_id, null: false
      t.string :time_zone
      t.text :description
      t.timestamps
    end
    add_index :tutors, :user_id, unique: true
    add_index :tutors, :slug, unique: true
  end
end
