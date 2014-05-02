# /app/models/lesson.rb
class Lesson < ActiveRecord::Base
  extend FriendlyId

  COMPLETE_ATTRIBUTES = [ :description, :location,
                          :lat, :long, :phone_number, :amount
                        ]
  validates *COMPLETE_ATTRIBUTES, presence: true
  enum level: [:beginner, :intermediate, :advanced]
  friendly_id :name, use: :slugged
  belongs_to :tutor, inverse_of: :lessons
end
