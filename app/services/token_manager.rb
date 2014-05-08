# /app/services/token_manager.rb
class TokenManager
  def initialize(reservation)
    @reservation = reservation
    @purchase_account = PurchaseAccount.for(reservation.student, reservation.lesson)
    @student = @purchase_account.student
  end

  def bookable?
    !@reservation.persisted? && (trial? || package? || paid? || free? || comped?)
  end

  def use_token
    if trial?
      @reservation.reservation_type = 'trial'
      @purchase_account.trial_tokens -= 1
    elsif paid?
      @reservation.reservation_type = 'paid'
      purchases = Purchase.where(student_id: @reservation.student,
                                 lesson_id: @reservation.lesson,
                                 description: 'Lesson').order('created_at ASC')
      @reservation.purchase = purchases.select { |n| n.lessons_unfinished > 0 }.first
      @purchase_account.paid_tokens -= 1
    elsif free?
      @reservation.reservation_type = 'free'
      @purchase_account.free_tokens -= 1
    elsif package?
      @reservation.reservation_type = 'package'
      @reservation.discounter = package.discounter
    elsif comped?
      @reservation.reservation_type = 'comped'
      @purchase_account.comped_tokens -= 1
    else
      return false
    end
    @purchase_account.save
  end

  def return_token
    token_type = "#{@reservation.reservation_type}_tokens".to_sym
    if package?
      true
    else
      @purchase_account.update_column(token_type, @purchase_account.send(token_type) + 1)
      @reservation.update_column(:purchase_id, nil)
      @reservation.save && @purchase_account.save
    end
  end

  private

  def trial?
    @reservation.reservation_type == 'trial' ||
    @purchase_account.trial_tokens > 0
  end

  def free?
    @reservation.reservation_type == 'free' ||
    @purchase_account.free_tokens > 0
  end

  def comped?
    @reservation.reservation_type == 'comped' ||
    @purchase_account.comped_tokens > 0
  end

  def paid?
    @reservation.reservation_type == 'paid' ||
    @purchase_account.paid_tokens > 0
  end

  def package?
    # @reservation.reservation_type == 'package' ||
    # !package.nil?
  end

  # def package
  #   @package ||= @student.package_coupons.select {|n| n.current_tokens > 0}.first
  # end
end
