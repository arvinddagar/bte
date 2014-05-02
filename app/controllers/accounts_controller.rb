class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def tutor_dashboard
    @lessons = current_user.tutor.lessons
  end
end
