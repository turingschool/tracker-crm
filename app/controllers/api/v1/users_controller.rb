module Api
  module V1
    class UsersController < ApplicationController
      def create
        authorize User
        user = User.new(user_params)
        if user.save
          render json: UserSerializer.new(user), status: :created
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
        end
      end

      def index
        authorize User
        render json: UserSerializer.format_user_list(User.all)
      end

      def show
        user = User.find(params[:id])
        authorize user
        render json: UserSerializer.new(User.find(params[:id]))
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
