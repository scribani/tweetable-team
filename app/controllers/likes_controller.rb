class LikesController < ApplicationController
  def new
    @like = Like.new
  end

  def create
    @like = Like.new(like_params)
    @like.user = User.first
    if @like.save
      redirect_back fallback_location: '/'
    else
      render :new
    end
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :tweet_id)
  end
end
