module Api
  class LikesController < ApiController
    # GET /api/users/:user_id/likes
    def index
      render_like(Like.where(user_id: params[:user_id]), :ok)
    end

    # POST /api/likes
    def create
      like = Like.new(tweet_id: params[:tweet_id])
      like.user = current_user

      if like.save
        render_like(like, :created)
      else
        bad_request like.errors
      end
    end

    # DELETE /api/likes/:id
    def destroy
      @like = Like.find(params[:id])
      authorize @like

      @like.destroy
      head :no_content
    end

    private

    def render_like(model, status)
      render json: model,
             only: %i[id],
             include: { tweet: {
               only: %i[id body replies_count likes_count replied_to_id],
               include: { replies: { only: %i[id body] } }
             } },
             status: status
    end
  end
end
