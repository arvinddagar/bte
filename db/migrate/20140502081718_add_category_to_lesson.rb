class AddCategoryToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :category_id, :integer, index: true
  end
end
