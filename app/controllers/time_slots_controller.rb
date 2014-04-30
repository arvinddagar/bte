class TimeSlotsController < ApplicationController
  before_action :set_time_slot, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :load_tutor

  def create
    @time_slot = @tutor.time_slots.build(time_slot_params)
    @time_slot.save!
    render nothing: true
  end


  # POST /time_slots
  # def create
  #   @time_slot = TimeSlot.new(time_slot_params)

  #   if @time_slot.save
  #     redirect_to @time_slot, notice: 'Time slot was successfully created.'
  #   else
  #     render :new
  #   end
  # end


  # DELETE /time_slots/1
  def destroy
    @time_slot.destroy
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_slot
      @time_slot = TimeSlot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def time_slot_params
      params[:time_slot]
    end

    def load_tutor
      @tutor = current_user.tutor
    end
end

