require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  def create_admin
    admin_data = {
      name: 'Test Admin',
      username: 'test_admin',
      email: 'test_admin@mail.com',
      password: 'supersecret',
      role: 'admin'
    }
    User.create(admin_data)
  end

  def create_user
    user_data = {
      email: 'test@mail.com',
      username: 'tester',
      name: 'Test User',
      password: '123456',
      role: 'member'
    }
    User.create(user_data)
  end

  def create_tweet(user)
    Tweet.create(body: 'This is what I wrote as a tweet', user: user)
  end

  before(:all) do
    create_admin

    params = { user: {
      email: 'test_admin@mail.com',
      password: 'supersecret'
    } }
    post '/api/login', params: params
    parsed_response = JSON.parse(response.body)

    @headers = { Authorization: "Bearer #{parsed_response['token']}" }
  end

  after(:all) do
    User.destroy_all
  end

  describe 'index path' do
    before(:each) do
      @user = create_user
    end

    it 'respond with http success status code' do
      get api_user_likes_path(@user), headers: @headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns a json with all tweets that are liked' do
      tweet = create_tweet(@user)
      Like.create(user: @user, tweet: tweet)

      get api_user_likes_path(@user), headers: @headers

      likes = JSON.parse(response.body)
      expect(likes.size).to eq 1
      expect(likes.first['tweet']['id']).to equal(tweet.id)
    end
  end

  describe 'create path' do
    before(:each) do
      user = create_user
      @tweet = create_tweet(user)
    end

    it 'respond with http created status code' do
      post api_likes_path, params: { tweet_id: @tweet.id }, headers: @headers

      expect(response).to have_http_status(:created)
    end

    it 'respond with a valid json' do
      post api_likes_path, params: { tweet_id: @tweet.id }, headers: @headers

      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'returns the tweet that was liked' do
      post api_likes_path, params: { tweet_id: @tweet.id }, headers: @headers

      created_like = JSON.parse(response.body)
      expect(created_like['id']).not_to be_nil
      expect(created_like['tweet']['id']).to eq(@tweet.id)
    end

    it 'shows error if no user_id or tweet_id' do
      post api_likes_path, params: { tweet_id: 'xxx' }, headers: @headers

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
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
      delete api_like_path(@like), headers: @headers

      expect(response).to have_http_status(:no_content)
    end

    it 'returns empty body' do
      delete api_like_path(@like), headers: @headers

      expect(response.body).to be_empty
    end

    it 'decrement by 1 the total of likes' do
      expect { delete api_like_path(@like), headers: @headers }.to change(Like, :count).by(-1)
    end

    it 'delete the requested like' do
      delete api_like_path(@like), headers: @headers

      expect { Like.find(@like.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
