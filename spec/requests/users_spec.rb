require 'rails_helper'

RSpec.describe 'Users', type: :request do
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

  def create_user(data)
    User.create(data)
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

  describe 'show path' do
    it 'respond with http success status code' do
      user = create_user(@user_data)

      get api_user_path(user), headers: @headers

      expect(response).to have_http_status(:ok)
    end

    it 'respond with the correct user' do
      user = create_user(@user_data)

      get api_user_path(user), headers: @headers

      actual_user = JSON.parse(response.body)
      expect(actual_user['id']).to eql(user.id)
    end

    it 'returns http status not found' do
      get '/api/users/:id', params: { id: 'xxx' }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'create path' do
    it 'respond with http created status code' do
      params = {
        user: @user_data,
        password: @user_data[:password]
      }
      post api_users_path, params: params, headers: @headers

      expect(response).to have_http_status(:created)
    end

    it 'respond with a valid json' do
      params = {
        user: @user_data,
        password: @user_data[:password]
      }
      post api_users_path, params: params, headers: @headers

      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'returns the created user' do
      params = {
        user: @user_data,
        password: @user_data[:password]
      }
      post api_users_path, params: params, headers: @headers

      created_user = JSON.parse(response.body)
      expect(created_user['id']).not_to be_nil
      expect(created_user['username']).to eq(params[:user][:username])
    end

    it 'shows error if no name, username or email' do
      data = @user_data.clone
      data[:name] = ''
      data[:username] = ''
      data[:email] = ''

      params = { user: data }
      post api_users_path, params: params, headers: @headers

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(errors['name'].first).to eq("can't be blank")
      expect(errors['username'].first).to eq("can't be blank")
      expect(errors['email'].first).to eq("can't be blank")
    end

    it 'shows error if duplicate email or username' do
      create_user(@user_data)

      params = {
        user: @user_data,
        password: @user_data[:password]
      }
      post api_users_path, params: params, headers: @headers

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(errors['username'].first).to eq('has already been taken')
      expect(errors['email'].first).to eq('has already been taken')
    end
  end

  describe 'update path' do
    before(:each) do
      @user = create_user(@user_data)
      @params = { user: { name: 'Updated user name' } }
    end

    it 'respond with http success status code' do
      patch api_user_path(@user), params: @params, headers: @headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated user' do
      patch api_user_path(@user), params: @params, headers: @headers

      updated_user = JSON.parse(response.body)
      expect(updated_user['id']).to equal(@user.id)
      expect(updated_user['name']).to eq(@params[:user][:name])
    end

    it 'shows error if no name, username or email' do
      params = { user: {
        name: '',
        username: '',
        email: ''
      } }
      patch api_user_path(@user), params: params, headers: @headers

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(errors['name'].first).to eq("can't be blank")
      expect(errors['username'].first).to eq("can't be blank")
      expect(errors['email'].first).to eq("can't be blank")
    end

    it 'shows error if duplicate email or username' do
      data = @user_data.clone
      data[:username] = 'tester2'
      data[:email] = 'test2@mail.com'
      user2 = User.create(data)

      params = { user: {
        username: 'tester',
        email: 'test@mail.com'
      } }
      patch api_user_path(user2), params: params, headers: @headers

      errors = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(errors['username'].first).to eq('has already been taken')
      expect(errors['email'].first).to eq('has already been taken')
    end
  end
end
