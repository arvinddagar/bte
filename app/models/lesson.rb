# /app/models/lesson.rb
class Lesson < ActiveRecord::Base
  extend FriendlyId

  LOCATION_ATTRIBUTES = [:lat, :long]

  COMPLETE_ATTRIBUTES = [ :name, :description, :location,
                          :phone_number, :amount
                        ]
  #validates *COMPLETE_ATTRIBUTES, presence: true
  enum level: [:beginner, :intermediate, :advanced]
  friendly_id :name, use: :slugged
  belongs_to :tutor, inverse_of: :lessons
  belongs_to :category
end
