# /app/controllers/time_slots_controller.rb
class TimeSlotsController < ApplicationController
  before_action :set_time_slot, only: [:destroy]
  before_filter :authenticate_user!
  before_filter :load_lesson

  def create
    @time_slot = @lesson.time_slots.create(time_slot_params)
  end

  def destroy
    @time_slot.destroy
  end

  private

  def set_time_slot
    @time_slot = TimeSlot.find(params[:id])
  end

  def time_slot_params
    params.require(:time_slot).permit(:starts_at_minutes)
  end

  def load_lesson
    @lesson = current_user.tutor.lessons.friendly.find(params[:lesson_id])
  end
end
