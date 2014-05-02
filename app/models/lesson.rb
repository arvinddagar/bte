# /app/models/lesson.rb
class Lesson < ActiveRecord::Base
  extend FriendlyId

  LOCATION_ATTRIBUTES = [:lat, :long]

  COMPLETE_ATTRIBUTES = [ :name, :description, :location,
                          :phone_number, :amount,
                          :start_date, :end_date
                        ]
  #validates *COMPLETE_ATTRIBUTES, presence: true
  enum level: [:beginner, :intermediate, :advanced]
  friendly_id :name, use: :slugged
  belongs_to :tutor, inverse_of: :lessons
  belongs_to :category

  class << self
    def past_classes
      where('end_date < ?', Date.today)
    end

    def active_classes
      where('end_date >= ?', Date.today)
    end
  end
end
