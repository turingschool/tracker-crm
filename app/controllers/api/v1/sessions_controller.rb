module Api
  module V1
    class SessionsController < ApplicationController
      before_action :skip_authorization

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = generate_token(user_id: user.id)
          render json: { token: token, user: UserSerializer.new(user) }, status: :ok
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new("Invalid login credentials", 401)), status: :unauthorized
        end
      end

      private

      def generate_token(payload)
        payload[:exp] = 24.hours.from_now.to_i
        JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
      end
    end
  end
end