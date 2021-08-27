class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      flash[:alert] = 'Please, sign up manually'
      redirect_to new_user_registration_path
    end
  end

  def failure
    redirect_to new_user_registration_path
  end
end
