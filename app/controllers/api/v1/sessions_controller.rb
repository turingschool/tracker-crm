module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          session[:user_id] = user.id
          render json: UserSerializer.new(user)
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new("Invalid login credentials", 401)), status: :unauthorized
        end
      end
    end
  end
end