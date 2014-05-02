class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def tutor_dashboard
    @past_lessons = current_user.tutor.lessons.past_classes
    @active_classes = current_user.tutor.lessons.active_classes
  end
end
