class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    return redirect_to root_path unless @user

    @tweets = Tweet.where(user_id: params[:id])
    @likes = Like.where(user_id: params[:id])
    @likeds = Tweet.where(id: @likes.pluck(:tweet_id))
  end
end
