class PurchaseAccount < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :student

  validates_presence_of :tutor, :student
  validates_uniqueness_of :student_id, scope: :tutor_id, message: 'already has purchase account for this tutor'

end
