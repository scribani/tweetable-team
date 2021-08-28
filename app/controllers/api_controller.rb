class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pundit

  before_action :authorize_token

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { message: e.message }, status: :bad_request
  end

  rescue_from Pundit::NotAuthorizedError do |e|
    unauthorized_request e.message
  end

  def current_user
    @current_user ||= authenticate_token
  end

  def authorize_token
    authenticate_token || unauthorized_request('Access denied')
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      User.find_by(token: token)
    end
  end

  def bad_request(messages)
    render json: messages, status: :bad_request
  end

  def unauthorized_request(message)
    render json: { message: message }, status: :unauthorized
  end

  def not_modified_request(message)
    render json: { message: message }, status: :not_acceptable
  end
end
