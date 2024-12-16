module Api
  module V1
    class UsersController < ApplicationController

      def create
        user = User.new(user_params)
        authorize user

        if user.save
          render json: UserSerializer.new(user), status: :created
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
        end
      end

      def index
        users = policy_scope(User)
        authorize users
        render json: UserSerializer.format_user_list(User.all)
      end

      def show
        @user = authorize User.find(params[:id])
        render json: UserSerializer.new(User.find(params[:id]))
      end

      def update
        user = User.find(params[:id])
        authorize user
        user.assign_attributes(user_params)
        if user.save
          render json: UserSerializer.new(user), status: :ok
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
