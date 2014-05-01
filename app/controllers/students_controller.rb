# /app/controllers/students_controller.rb
class StudentsController < ApplicationController
  skip_before_filter :redirect_user_with_incomplete_registration,
                     only: [:complete_registration, :update]

  before_filter :authenticate_user!,
                only: [:index, :complete_registration, :update]

  def new
    @student = Student.new
    @student.build_user
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      sign_in @student.user
      redirect_to root_url
    else
      flash.now[:alert] = 'Error in registration. !!'
      render :new
    end
  end

  def update
    @student = current_user.student
    if @student.update_attributes(update_student_params)
      redirect_to root_url
    #   if current_user.sessions_count <= 0
    #     session[:next_page_after_session_test] = new_payment_url
    #   end
    #   redirect_to session_test_url
    # else
    #   render :complete_registration
    end
  end

  def complete_registration
    @student = current_user.student
  end

  private

  def student_params
    params.require(:student)
          .permit(:username, user_attributes: [:email, :password])
  end

  def update_student_params
    params.require(:student).permit(Student::COMPLETE_ATTRIBUTES)
  end
end
