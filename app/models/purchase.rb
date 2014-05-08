# /app/models/purchase.rb
class Purchase < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :student
  has_many :reservations

  PAYMENT_METHODS = {
    stripe: 'stripe'
  }

  def lessons_remaining
    difference = lessons_purchased - lessons.count
    [difference, 0].max # don't return negative values
  end

  # lessons remaining + lessons in progress
  def lessons_unfinished
    lessons_purchased - lessons_completed - reservations.count
  end

  def lesson_left(type)
    tokencount = PurchaseAccount.for(student, teacher)
    if type == 'comped'
      return tokencount.comped_tokens
    elsif type == 'free'
      return tokencount.free_tokens
    elsif type == 'trial'
      return tokencount.trial_tokens
    end
  end

  def lessons_remaining?
    lessons_remaining > 0
  end

  def lessons_completed
    completed = 0
    Reservation.where('reservations.lesson_id = ? and reservations.student_id = ? and reservations.state = ?', lesson, student, 'completed').find_in_batches do |reservations|
      completed += reservations.count
    end
    completed.to_i
  end

  def amount
    self[:amount] || original_amount
  end

  def amount_in_cents
    (amount * 100).to_i
  end

  def save_and_charge!(stripe_token)
    Purchase.transaction do
      apply_discount!
      raise ActiveRecord::Rollback unless save
      account.update_attributes!(paid_tokens: (account.paid_tokens + lessons_purchased))
      return true if amount == 0
      begin
        charge = Stripe::Charge.create(
          amount: amount_in_cents,
          currency: 'usd',
          card: stripe_token,
          description: %Q({"trainer_email":"#{lesson.tutor.email}","student_email":"#{student.email}","lesson_id":#{lesson_id},"student_id":#{student_id},"original_amount":#{amount}}))
        update_attribute(:stripe_charge_id, charge.id)
        return true
      rescue Stripe::CardError => ex
        errors.add(:base, ex.message)
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def account
    PurchaseAccount.for(student, lesson)
  end

  def apply_discount!
  #   if discounter
  #     DiscounterApplier.new(discounter, self).apply!
  #     raise ActiveRecord::Rollback if discounter.strategy.changed? && !discounter.strategy.save
  #   end
  # rescue DiscounterStrategy::DiscounterUnusableError => e
  #   raise ActiveRecord::Rollback
  end
end
