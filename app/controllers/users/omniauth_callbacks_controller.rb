class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @student = User.find_for_facebook_oauth(request.env['omniauth.auth'])

    if @student.persisted?
      sign_in @student.user, event: :authentication
      redirect_to root_url
      # sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      # redirect_to new_user_registration_url
      redirect_to root_url
    end
  end
end