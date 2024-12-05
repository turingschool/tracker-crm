module Api
  module V1
    class ContactsController < ApplicationController
      before_action :authenticate_user

      def index
        contacts = @current_user.contacts
        if contacts.nil?
          render json: { data: [], message: "No contacts found" }
        else
          render json: ContactsSerializer.new(contacts), status: :ok
        end
      end

      private

      # def authenticate_user
      #   token = request.headers['Authorization']&.split(' ')&.last
      #   if token
      #     begin
      #       payload = decoded_token(token)
      #       @current_user = User.find_by(id: payload[:user_id])
      #     rescue JWT::DecodeError
      #       @current_user = nil
      #     end
      #   end
      #   render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      # end

      # def decoded_token(token)
      #   JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0].symbolize_keys
      # end

    end
  end
end
