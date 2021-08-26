class TweetsController < ApplicationController
  def index
    @tweets = Tweet.where(replied_to_id: nil).order(created_at: :desc,
                                                    replies_count: :desc).page(params[:page]).per(5)
    @currentuser = current_user
  end

  def show
    @tweet = Tweet.find_by(id: params[:id])
    @currentuser = current_user
    return redirect_to root_path unless @tweet

    @replies = @tweet.replies.order(created_at: :desc,
                                    replies_count: :desc).page(params[:page]).per(5)
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user
    if @tweet.save
      redirect_to @tweet
    else
      flash[:alert] = @tweet.errors.full_messages.join("\n")
      redirect_to root_path
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_back fallback_location: '/'
  end

  # GET /tweets/:id/edit
  def edit
    @tweet = Tweet.find(params[:id])
  end

  # PATCH/PUT /tweets/:id
  def update
    @tweet = Tweet.find(params[:id])

    return redirect_to @tweet if @tweet.update(tweet_params)

    render :edit
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :replied_to_id)
  end
end
