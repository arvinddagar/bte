# /app/models/tutor.rb
class Tutor < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  PROPERTIES = [
    :description
  ]
  OTHER_REQUIRED_ATTRIBUTES = [
    :name
  ]
  COMPLETE_ATTRIBUTES = PROPERTIES +
    OTHER_REQUIRED_ATTRIBUTES

  belongs_to :user
  accepts_nested_attributes_for :user
  delegate :email, to: :user, allow_nil: true
  validates :name, presence: true
  validates *COMPLETE_ATTRIBUTES, presence: true, on: :update

  has_many :lessons, dependent: :destroy, inverse_of: :tutor

  def to_s
    name
  end

  def avatar_url
    avatar && avatar.fullpath(
      width: 100,
      height: 100,
      crop: :thumb,
      gravity: :face,
      secure: true
    )
  end

  def complete?
    COMPLETE_ATTRIBUTES.all? { |attr| send(attr).present? }
  end

  def incomplete?
    !complete?
  end

  def attrs
    {
      tutor_id: id
    }
  end
end
