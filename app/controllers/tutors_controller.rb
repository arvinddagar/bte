# /app/controllers/tutors_controller.rb
class TutorsController < ApplicationController
  skip_before_filter :redirect_user_with_incomplete_registration,
                     only: [:complete_registration, :update]

  before_filter :authenticate_user!,
                only: [:index, :complete_registration, :update]

  def new
    @tutor = Tutor.new
    @tutor.build_user
  end

  def create
    @tutor = Tutor.new(tutor_params)
    if @tutor.save
      sign_in @tutor.user
      # WelcomeMailer.new_tutor_email(@tutor.user.email).deliver
      redirect_to root_url
    else
      flash.now[:alert] = 'Error in registration'
      render :new
    end
  end

  def complete_registration
    @tutor = current_user.tutor
  end

  def update
    @tutor = current_user.tutor
    if @tutor.update_attributes(update_tutor_params)
      redirect_to root_url
    else
      render :complete_registration
    end
  end

  private

  def tutor_params
    params.require(:tutor).permit(:name, user_attributes: [:email, :password])
  end

  def update_tutor_params
    attrs = []
    attrs.push(*Tutor::COMPLETE_ATTRIBUTES)
    attrs.push(*Tutor::LANGUAGE_ATTRS)
    attrs.push(:avatar)
    attrs.push(teaching_learner_profiles: [])
    params.require(:tutor).permit(attrs)
  end
end
