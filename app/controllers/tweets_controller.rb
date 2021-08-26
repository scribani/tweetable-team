class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = Tweet.find(params[:id])
    @replies = @tweet.replies
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(body: params[:body], user_id: 1)
    if @tweet.save
      redirect_back fallback_location: '/'
    else
      render :new
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
    params.require(:tweet).permit(:body, :replied_to)
  end
end
