# /app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :redirect_user_with_incomplete_registration
  around_filter :set_time_zone

  helper_method :pages_list,
                :current_student,
                :current_tutor

  private

  def pages_list
    @pages ||= Page.all
  end

  def set_time_zone
    if current_user.try(:tutor?) || current_user.try(:student?)
      Time.zone = current_user.timezone
    elsif cookies[:tz_olson]
      Time.zone = ::OlsonTimezones.timezones_from_olson(cookies[:tz_olson]).first
    else
      Time.zone = 'UTC'
    end
    yield
    ensure
    Time.zone = 'UTC'
  end

  def redirect_user_with_incomplete_registration
    return if request.path == destroy_user_session_path
    if current_user && current_user.role && current_user.role.incomplete?
      redirect_to complete_registration_url
    end
  end

  def require_admin!
    if authenticate_user!
      render_404 unless current_user.admin?
    end
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.any  { head :not_found }
    end
  end

  def current_student
    current_user && current_user.student
  end

  def current_tutor
    current_user && current_user.tutor
  end

end
