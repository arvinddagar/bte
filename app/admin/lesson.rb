# /app/admin/lesson.rb
ActiveAdmin.register Lesson do
  before_filter only: [:show, :edit, :destroy] do
    @lesson = Lesson.friendly.find(params[:id])
  end

  index do
    column :name
    column :tutor_id
    column :slug
    column :address
    column :amount
    column :phone_number
    column :allowed_people
    column :lesson_duration
    column :time_slots_count
    column :category_id
    default_actions
  end
end

