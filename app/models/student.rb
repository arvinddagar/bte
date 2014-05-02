# /app/models/student.rb
class Student < ActiveRecord::Base
  PROPERTIES = [
    :description
  ]

  COMPLETE_ATTRIBUTES = PROPERTIES + [
    :username
  ]

  belongs_to :user

  has_many :purchases
  has_many :purchase_accounts

  accepts_nested_attributes_for :user

  validates :username, presence: true, uniqueness: true
  validates *COMPLETE_ATTRIBUTES, presence: true, on: :update

  delegate :email, to: :user, allow_nil: true

  def attrs
    {
      student_id: id
    }
  end

  def complete?
    COMPLETE_ATTRIBUTES.all? { |attr| send(attr).present? }
  end

  def incomplete?
    !complete?
  end
end
