module Api
  module V1
    class ContactsController < ApplicationController
      before_action :authenticate_user

      def index
        contacts = @current_user.contacts
        if contacts.empty?
          render json: { data: [], message: "No contacts found" }, status: :ok
        else
          render json: ContactsSerializer.new(contacts), status: :ok
        end
      end

    end
  end
end
