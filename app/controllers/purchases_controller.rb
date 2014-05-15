# /app/controllers/purchases_controller.rb
class PurchasesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include PaymentsHelper

  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  def new
    @purchase = Purchase.new
    @lesson   = Lesson.friendly.find(params[:lesson] || params[:reservation][:lesson_id])
    if params[:reservation]
      @reservation = current_user.student.reservations.build reservation_params
      reserve if TokenManager.new(@reservation).bookable?
    end
  end

  def create
    @purchase                   = current_user.student.purchases.new(purchase_params)
    @purchase.description       = 'Lesson'
    @purchase.lessons_purchased = 1
    lesson                      = Lesson.friendly.find(params[:purchase][:lesson_id])
    @purchase.amount            = lesson.amount

    if @purchase.save_and_charge! params[:stripeToken]
      if params[:reservation]
        @reservation = Reservation.new JSON.load params[:reservation]
        if @reservation.save!
          redirect_to reservations_path, notice: 'Your purchase is complete and your lesson is booked. You will receive an email shortly with lesson details.'
        else
          redirect_to lesson_path(@purchase.lesson), notice: 'Your purchase is complete, but your lesson could not be booked.  Please choose a new time slot.'
        end
      else
        if @purchase.lesson.time_slots_count > 0
          redirect_to lesson_path(@purchase.lesson), notice: "Your purchase is complete. Click 'Book Now' to reserve a time slot with #{@purchase.lesson.name.titleize}."
        else
          redirect_to lesson_path(@purchase.lesson), notice: "Your purchase is complete. Contact #{@purchase.lesson.name.titleize} to request a lesson time."
        end
      end
    else
      flash.now[:error] = @purchase.errors[:base].join(' ')
      render :new
    end
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  def purchase_params
    params.require(:purchase).permit(:lesson_id, :student_id,
                                     :stripe_charge_id, :description,
                                     :lessons_purchased, :amount,
                                     :original_lessons_purchased,
                                     :coupon_id, :original_amount,
                                     :discounter_id, :payment_method)
  end

  def reserve
    if @reservation.save
      if @reservation.reservation_type == 'trial'
        redirect_to confirm_reservation_path @reservation
      else
        redirect_to reservations_path, notice: 'Your booking is confirmed. You will receive an email shortly with lesson details.'
      end
    else
      redirect_to tutor_path(@tutor), notice: @reservation.errors.full_messages.to_sentence
    end
  end

  def reservation_params
    params.require(:reservation).permit(:ends_at, :starts_at, :lesson_id)
  end
end
