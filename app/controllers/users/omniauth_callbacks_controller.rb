# /app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @student = User.find_for_facebook_oauth(request.env['omniauth.auth'])
    if @student.persisted?
      sign_in @student.user, event: :authentication
      redirect_to root_url
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to root_url
    end
  end
end
