class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :username, null: false
      t.integer :user_id, null: false
      t.string :time_zone
      t.timestamps
    end
    add_index :students, :username, unique: true
    add_index :students, :user_id, unique: true
  end
end