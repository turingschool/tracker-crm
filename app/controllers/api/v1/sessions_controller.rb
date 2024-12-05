module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = encode_token(user)
          render json: { token: token, user: UserSerializer.new(user)}, status: :ok
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new("Invalid login credentials", 401)), status: :unauthorized
        end
      end

      private

      def encode_token(user)
        payload = {
          user_id: user.id,
          exp: 24.hours.from_now.to_i
        }
        secret_key = Rails.application.secret_key_base
        JWT.encode(payload, secret_key, 'HS256')
      end
    end
  end
end