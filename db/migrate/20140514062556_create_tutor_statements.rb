class CreateTutorStatements < ActiveRecord::Migration
  def change
    create_table :tutor_statements do |t|
      t.integer :week
      t.integer :month
      t.integer :year
      t.integer :teacher_id, index: true
      t.boolean :finalized
      t.boolean :published
      t.integer :commission
      t.binary :pdf
      t.integer :lesson_count, default: 0
      t.timestamps
    end
  end
end
