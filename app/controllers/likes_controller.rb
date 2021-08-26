class LikesController < ApplicationController
  def create
    user = User.find_by(id: params[:user_id])
    tweet = Tweet.find_by(id: params[:tweet_id])
    like = Like.new(user: user, tweet: tweet)
    like.save
    redirect_back fallback_location: '/'
  end

  def destroy
    like = Like.find_by(id: params[:id])
    like.destroy
    redirect_back fallback_location: '/'
  end
end
