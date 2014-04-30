class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.string :name
      t.integer :user_id, null: false
      t.hstore :properties
      t.timestamps
    end
    add_index :tutors, :user_id, unique: true
    execute 'CREATE INDEX tutors_properties ON tutors USING gin(properties)'
  end
end
