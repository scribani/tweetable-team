require 'rails_helper'

def create_user
  user_data = {
    email: 'test@mail.com',
    username: 'tester',
    name: 'Test User',
    role: 'member'
  }
  User.create(user_data)
end

def create_tweet(user)
  Tweet.create(body: 'This is what I wrote as a tweet', user: user)
end

RSpec.describe 'Likes', type: :request do
  describe 'index path' do
    before(:each) do
      @user = create_user
    end

    it 'respond with http success status code' do
      get api_user_likes(@user)

      expect(response).to have_http_status(:ok)
    end

    it 'returns a json with all tweets that are liked' do
      tweet = create_tweet(@user)
      Like.create(user: @user, tweet: tweet)

      get api_user_likes(@user)

      likes = JSON.parse(response.body)
      expect(likes.size).to eq 1
      expect(likes.first['tweet']['id']).to equal(tweet.id)
    end
  end

  describe 'create path' do
    before(:each) do
      @user = create_user
      @tweet = create_tweet(@user)
    end

    it 'respond with http created status code' do
      params = { like: {
        user: @user,
        tweet: @tweet
      } }
      post api_user_likes(@user), params: params

      expect(response).to have_http_status(:created)
    end

    it 'respond with a valid json' do
      params = { like: {
        user: @user,
        tweet: @tweet
      } }
      post api_user_likes(@user), params: params

      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'returns the tweet that was liked' do
      params = { like: {
        user: @user,
        tweet: @tweet
      } }
      post api_user_likes(@user), params: params

      created_like = JSON.parse(response.body)
      expect(created_like['id']).not_to be_nil
      expect(created_like['tweet']['id']).to eq(params[:like][:tweet].id)
    end

    it 'shows error if no user_id or tweet_id' do
      params = { like: {
        user: nil,
        tweet: nil
      } }
      post api_user_likes(@user), params: params

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(errors['user'].first).to eq('must exist')
      expect(errors['tweet'].first).to eq('must exist')
    end
  end

  describe 'destroy path' do
    before(:each) do
      user = create_user
      tweet = create_tweet(user)
      @like = Like.create(user: user, tweet: tweet)
    end

    it 'respond with http no content status code' do
      delete api_user_like(@like)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns empty body' do
      delete api_user_like(@like)

      expect(response.body).to be_empty
    end

    it 'decrement by 1 the total of likes' do
      expect { delete api_user_like(@like) }.to change(Like, :count).by(-1)
    end

    it 'delete the requested like' do
      delete api_user_like(@like)

      expect { Like.find(@like.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
