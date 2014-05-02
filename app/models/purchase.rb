class Purchase < ActiveRecord::Base
  # belongs_to :tutor
  # belongs_to :student

  # validates :tutor, :student, presence: true
  # validates :lessons_purchased, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }

  PAYMENT_METHODS = {
    stripe: 'stripe'
  }
end
