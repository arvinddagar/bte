# /app/models/lesson.rb
class Lesson < ActiveRecord::Base
  extend FriendlyId

  acts_as_commentable
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  LOCATION_ATTRIBUTES = [:latitude, :longitude]

  COMPLETE_ATTRIBUTES = [ :name, :description, :address,
                          :phone_number, :amount,
                          :start_date, :end_date,
                          :allowed_people
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

    def search(search)
      wildcard_search = "%#{search}%"
      where("address LIKE :search OR description LIKE :search OR name LIKE :search", search: wildcard_search)
    end
  end
end