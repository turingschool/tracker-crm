class ApplicationController < ActionController::API
  include Pundit::Authorization
  after_action :verify_authorized

  # temporary current_user testing stub until we add in authentication
  def current_user
    @current_user ||= User.find_by(email: "test@test.com")
  end

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        payload = decoded_token(token)
        @current_user = User.find_by(id: payload[:user_id])
        @current_user_roles = payload[:roles]
      rescue JWT::DecodeError
        @current_user = nil
      end
    end
    render json: { error: 'Not authenticated' }, status: :unauthorized unless @current_user
  end

  def decoded_token(token)
    JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0].symbolize_keys
  end
end
