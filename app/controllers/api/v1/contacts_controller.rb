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

			def create 
				contact = @current_user.contacts.new(contact_params)
				if contact.save
					render json: ContactsSerializer.new(contact), status: :created
				else
					render json: { error: contact.errors.full_messages.to_sentence }, status: :unprocessable_entity
				end
			end

			private

			def contact_params
				params.require(:contact).permit(:first_name, :last_name, :company_id, :email, :phone_number, :notes)
			end
	  end
  end
end
