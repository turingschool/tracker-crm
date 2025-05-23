class ApplicationController < ActionController::API
  include Pundit::Authorization
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  
  def current_user
    @current_user ||= self.authenticate_user
  end

  private

  def user_not_authorized
    render json: { error: "Not authorized" }, status: :forbidden
  end

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
    return @current_user
  end

  def decoded_token(token)
    JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0].symbolize_keys
  end
end
