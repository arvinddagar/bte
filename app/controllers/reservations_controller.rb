# /app/controllers/reservations_controller.rb
class ReservationsController < ApplicationController

  before_filter :authenticate_user!, except: [:available, :days]

  def index
    ReservationUpdater.call
    @reservations = current_user.tutor.try(:reservations) || current_user.student.try(:reservations)
  end

  def available
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @from = params[:from]
    @reservations = ReservationGenerator.new(@lesson).for_date(@from)
  end

  def days
    from = params[:from] || Time.now
    @lesson = Lesson.friendly.find(params[:lesson_id])
    rg = ReservationGenerator.new(@lesson)
    @days = rg.starting_on(from.to_date).map {|r| r.starts_at.to_date }.uniq.first(1)
    @reservations = @days.empty? ? [] : rg.for_date(@days.first)
  end
end
