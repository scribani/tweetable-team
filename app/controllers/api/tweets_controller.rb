module Api
  class TweetsController < ApiController
    before_action :set_tweet, only: %i[show update destroy]

    # GET /api/tweets
    def index
      render_tweet(Tweet.all, :ok)
    end

    # GET /api/tweets/:id
    def show
      render_tweet(@tweet, :ok)
    end

    # POST /api/tweets
    def create
      tweet = Tweet.new(tweet_params)
      tweet.user = current_user

      if tweet.save
        render_tweet(tweet, :created)
      else
        bad_request tweet.errors
      end
    end

    # PATCH/PUT /api/tweets/:id
    def update
      unpermitted_params = 'The only permitted parameters are [body, replied_to_id]'
      authorize @tweet

      if tweet_params.blank?
        not_modified_request unpermitted_params
      elsif @tweet.update(tweet_params)
        render_tweet(@tweet, :ok)
      else
        bad_request @tweet.errors
      end
    end

    # DELETE /api/tweets/:id
    def destroy
      authorize @tweet

      @tweet.destroy
      head :no_content
    end

    private

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:body, :replied_to_id)
    end

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def render_tweet(model, status)
      render json: model,
             only: %i[id body replies_count likes_count replied_to_id],
             include: { replies: { only: %i[id body] } },
             status: status
    end
  end
end
