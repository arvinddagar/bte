# /app/models/category.rb
class Category < ActiveRecord::Base
  has_many :childrens, class_name: 'Category',
                       foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category'
  has_many :lessons
  scope :main_categories, -> { where('parent_id IS NULL') }

  def to_s
    category_name
  end
end
