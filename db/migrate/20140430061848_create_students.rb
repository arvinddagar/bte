class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :username, null: false
      t.integer :user_id, null: false
      t.hstore :properties
      t.timestamps
    end
    add_index :students, :username, unique: true
    add_index :students, :user_id, unique: true
    execute 'CREATE INDEX students_properties ON students USING gin(properties)'
  end
end