class ApplicationController < ActionController::API

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        payload = decoded_token(token)
        @current_user = User.find_by(id: payload[:user_id])
      rescue JWT::DecodeError
        @current_user = nil
      end
    end
    render json: { error: 'Not authenticated' }, status: :unauthorized unless @current_user
  end


end
