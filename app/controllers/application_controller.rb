class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[index show]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def index; end

  def show; end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username name])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[username email name password password_confirmation
                                               current_password])
  end
end
