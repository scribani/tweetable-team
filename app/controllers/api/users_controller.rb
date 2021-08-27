module Api
  class UsersController < ApiController
    before_action :set_user, only: %i[show update]

    # GET /api/users/:id
    def show
      policy_scope User
      render json: @user,
             only: %i[id email username name role],
             include: { tweets: { only: %i[id replies_count likes_count] } }
    end

    # POST /api/users
    def create
      user = User.new(user_params)
      user.password = params[:password]
      authorize user

      if user.save
        render json: user, only: %i[id email username name role], status: :created
      else
        bad_request user.errors
      end
    end

    # PATCH/PUT /api/users/:id
    def update
      unpermitted_params = 'The only permitted parameters are [name, username, email]'
      authorize @user

      if user_params.blank?
        not_modified_request unpermitted_params
      elsif @user.update(user_params)
        render json: @user, only: %i[id email username name role]
      else
        bad_request @user.errors
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :username, :email)
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
