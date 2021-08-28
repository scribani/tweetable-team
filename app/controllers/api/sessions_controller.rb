module Api
  class SessionsController < ApiController
    skip_before_action :authorize_token, only: :create

    # POST /api/login
    def create
      user = User.find_by(email: params[:user][:email])
      if user&.valid_password?(params[:user][:password])
        user.regenerate_token
        render json: { token: user.token }
      else
        unauthorized_request 'Invalid user credentials'
      end
    end

    # POST /api/logout
    def destroy
      current_user.invalidate_token
      head :no_content
    end
  end
end
