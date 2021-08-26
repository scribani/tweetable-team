class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
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
end
