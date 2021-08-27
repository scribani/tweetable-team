require 'rails_helper'

describe 'Tweets', type: :request do
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
      password: '123456'
    }
    User.create(user_data)
  end

  before(:all) do
    create_admin
    @user_data = {
      email: 'test@mail.com',
      username: 'tester',
      name: 'Test User',
      password: '123456'
    }

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
    it 'respond with http success status code' do
      get '/api/tweets', headers: @headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns a json with all tweets' do
      user = create_user
      Tweet.create(body: 'This is what I wrote as a tweet', user: user)

      get '/api/tweets', headers: @headers

      tweets = JSON.parse(response.body)
      expect(tweets.size).to eq 1
    end
  end

  describe 'show path' do
    it 'respond with http success status code' do
      user = create_user
      tweet = Tweet.create(body: 'This is what I wrote as a tweet', user: user)

      get api_tweet_path(tweet), headers: @headers

      expect(response).to have_http_status(:ok)
    end

    it 'respond with the correct tweet' do
      user = create_user
      tweet = Tweet.create(body: 'This is what I wrote as a tweet', user: user)

      get api_tweet_path(tweet), headers: @headers

      actual_tweet = JSON.parse(response.body)
      expect(actual_tweet['id']).to eql(tweet.id)
    end

    it 'returns http status not found' do
      get '/api/tweets/:id', params: { id: 'xxx' }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'create path' do
    before(:each) do
      @user = create_user
    end

    it 'respond with http created status code' do
      params = { tweet: {
        body: 'This is what I wrote as a tweet',
        user: @user
      } }
      post api_tweets_path, params: params, headers: @headers

      expect(response).to have_http_status(:created)
    end

    it 'respond with http created status code when a reply is created' do
      parent_tweet = Tweet.create(body: 'This is the main tweet', user: @user)
      params = { tweet: {
        body: 'This is what I wrote as a tweet',
        user: @user,
        replied_to: parent_tweet
      } }
      post api_tweets_path, params: params, headers: @headers

      expect(response).to have_http_status(:created)
    end

    it 'respond with a valid json' do
      params = { tweet: {
        body: 'This is what I wrote as a tweet',
        user: @user
      } }
      post api_tweets_path, params: params, headers: @headers

      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'returns the created tweet' do
      params = { tweet: {
        body: 'This is what I wrote as a tweet',
        user: @user
      } }
      post api_tweets_path, params: params, headers: @headers

      created_tweet = JSON.parse(response.body)
      expect(created_tweet['id']).not_to be_nil
      expect(created_tweet['body']).to eq(params[:tweet][:body])
    end

    it 'shows error if no body' do
      post api_tweets_path, params: { tweet: { body: '' } }, headers: @headers

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(errors['body'].first).to eq("can't be blank")
    end

    it 'shows error if no valid replied_to_id' do
      params = { tweet: {
        body: 'This is what I wrote as a tweet',
        replied_to_id: 'xxx'
      } }
      post api_tweets_path, params: params, headers: @headers

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(errors['replied_to_id'].first).to eq('is not a valid tweet')
    end
  end

  describe 'update path' do
    before(:each) do
      user = create_user
      @tweet = Tweet.create(body: 'This is what I wrote as a tweet', user: user)
      @params = { tweet: { body: 'Updated tweet body' } }
    end

    it 'respond with http success status code' do
      patch api_tweet_path(@tweet), params: @params, headers: @headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated tweet' do
      patch api_tweet_path(@tweet), params: @params, headers: @headers

      updated_tweet = JSON.parse(response.body)
      expect(updated_tweet['id']).to equal(@tweet.id)
      expect(updated_tweet['body']).to eq(@params[:tweet][:body])
    end
  end

  describe 'destroy path' do
    before(:each) do
      user = create_user
      @tweet = Tweet.create(body: 'This is what I wrote as a tweet', user: user)
    end

    it 'respond with http no content status code' do
      delete api_tweet_path(@tweet), headers: @headers

      expect(response).to have_http_status(:no_content)
    end

    it 'returns empty body' do
      delete api_tweet_path(@tweet), headers: @headers

      expect(response.body).to be_empty
    end

    it 'decrement by 1 the total of tweets' do
      expect { delete api_tweet_path(@tweet), headers: @headers }.to change(Tweet, :count).by(-1)
    end

    it 'delete the requested tweet' do
      delete api_tweet_path(@tweet), headers: @headers

      expect { Tweet.find(@tweet.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
