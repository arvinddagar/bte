# /app/models/purchase_account.rb
class PurchaseAccount < ActiveRecord::Base

  belongs_to :lesson
  belongs_to :student

  before_save :remove_trial_tokens, if: :paid_tokens_changed?

  validates :lesson, :student, presence: true
  validates :student_id, uniqueness: { scope: :lesson_id, message: 'already has purchase account for this lesson' }


  def self.for(user1, user2)
    return nil unless (user1.is_a?(Lesson) && user2.is_a?(Student)) || (user1.is_a?(Student) && user2.is_a?(Lesson))
    attributes = {"#{user1.class_name}_id" => user1.id, "#{user2.class_name}_id" => user2.id}
    account = PurchaseAccount.where(attributes).first || PurchaseAccount.new(attributes, as: :factory)
    account.valid? ? account : nil
  end

  def tokens_remaining
    paid_tokens + comped_tokens + free_tokens + trial_tokens
  end

  def consume_token_with(reservation)
    if trial_tokens > 0
      reservation.reservation_type = 'trial'
      self.trial_tokens = trial_tokens - 1
      save
    elsif paid_tokens > 0
      reservation.purchase = purchases.select {|n| n.lessons_unfinished > 0}.first
      reservation.reservation_type = 'paid'
      self.paid_tokens = paid_tokens - 1
      save
    elsif free_tokens > 0
      reservation.reservation_type = 'free'
      self.free_tokens = free_tokens - 1
      save
    elsif comped_tokens > 0
      reservation.reservation_type = 'comped'
      self.comped_tokens = comped_tokens - 1
      save
    else
      false
    end
  end

  def return_token_for(reservation)
    token_type = "#{reservation.reservation_type}_tokens".to_sym
    update_attribute(token_type, send(token_type) + 1)
    reservation.update_attribute(:purchase_id, nil)
  end

  def trial_tokens
    self[:trial_tokens]
  end

  def free_tokens
    self[:free_tokens] or 0
  end

  def comped_tokens
    self[:comped_tokens] or 0
  end

  def purchases
    Purchase.where(student_id: student, lesson_id: lesson).order("created_at ASC")
  end

  private

  def reservations
    Reservation.where(student_id: student, lesson_id: lesson)
  end

  def remove_trial_tokens
    self.trial_tokens = 0
  end

end
