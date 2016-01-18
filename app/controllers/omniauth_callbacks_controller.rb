class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    #render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(reguest.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end
end