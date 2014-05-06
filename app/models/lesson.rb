# /app/models/lesson.rb
class Lesson < ActiveRecord::Base
  extend FriendlyId

  acts_as_commentable
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  LOCATION_ATTRIBUTES = [:latitude, :longitude]

  COMPLETE_ATTRIBUTES = [:name, :description, :address,
                         :phone_number, :amount,
                         :allowed_people, :green_zone,
                         :weeks_visible
                        ]
  # validates *COMPLETE_ATTRIBUTES, presence: true
  enum level: [:beginner, :intermediate, :advanced]
  friendly_id :name, use: :slugged
  has_many :time_slots, dependent: :destroy
  belongs_to :tutor, inverse_of: :lessons
  belongs_to :category

  class << self
    def past_classes
      where('id < ?', 1000) # Fix me use reservations
    end

    def active_classes
      where('id < ?', 1000) # Fix me use reservations
    end

    def search(search)
      wildcard_search = "%#{search}%"
      where('address LIKE :search OR description LIKE :search OR name LIKE :search', search: wildcard_search)
    end
  end
end
