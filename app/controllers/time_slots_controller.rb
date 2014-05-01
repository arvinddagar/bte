class TimeSlotsController < ApplicationController
  before_action :set_time_slot, only: [:destroy]
  before_filter :authenticate_user!
  before_filter :load_tutor
  respond_to :js, :json, :html

  # POST /time_slots
  def create
    @time_slot = @tutor.time_slots.create(time_slot_params)
  end

  # DELETE /time_slots/1
  def destroy
    @time_slot.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_time_slot
    @time_slot = TimeSlot.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def time_slot_params
    params.require(:time_slot).permit(:starts_at_minutes)
  end

  def load_tutor
    @tutor = current_user.tutor
  end
end

