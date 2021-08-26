class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = found_tweet
    @replies = @tweet.replies
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(body: params[:body], user_id: current_user.id)
    if @tweet.save
      redirect_to root
    else
      render :new
    end
  end

  def destroy
    @tweet = found_tweet
    @tweet.destroy
    redirect_to root
  end

  private

  def found_tweet
    Tweet.find(params[:id])
  end
end
