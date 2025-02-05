module Api
  module V1
    class ContactsController < ApplicationController
      before_action :authenticate_user

      def index
        if params[:company_id]
          if company = Company.find_company(@current_user, params[:company_id])
            authorize company
            render json: { company: CompanySerializer.new(company), contacts: ContactsSerializer.new(company.contacts) }
          else
            skip_authorization
            render json: { error: "Company not found or unauthorized access" }, status: :not_found
          end
        else
				  authorize Contact
          if (contacts = @current_user.contacts).empty?
            render json: { data: [], message: "No contacts found" }, status: :ok
          else
            render json: ContactsSerializer.new(contacts), status: :ok
          end
        end
      end

      def create 
        authorize Contact
        if (company = Company.find_company(@current_user, params[:company_id])) || params[:company_id].blank?
          contact = Contact.create_optional_company(contact_params, @current_user.id, params[:company_id])
          if contact.save
            render json: ContactsSerializer.new(contact), status: :created
          else
            render json: { error: contact.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        else
          return render json: { error: "Company not found" }, status: :not_found
        end
      end

      def show
        if params[:id].blank?
          render json: ErrorSerializer.format_error(ErrorMessage.new("Contact ID is missing", 400)), status: :bad_request
          return
        end

        user = User.find(params[:user_id])
        authorize user
    
        contact = Contact.find_by(id: params[:id])

        if contact.nil? || contact.user_id != user.id
          render json: ErrorSerializer.format_error(ErrorMessage.new("Contact not found", 404)), status: :not_found
        else
          contact_data = ContactsSerializer.new(contact)
          render json: contact_data, status: :ok
        end
      end

      private

      def contact_params
        params.require(:contact).permit(:first_name, :last_name, :company_id, :email, :phone_number, :notes)
      end
    end
  end
end
