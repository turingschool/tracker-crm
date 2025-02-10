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
            render json: ErrorSerializer.format_error(ErrorMessage.new("Company not found", 404)), status: :not_found
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
          if contact.persisted?
            render json: ContactsSerializer.new(contact), status: :created
          else
            render json: ErrorSerializer.format_error(ErrorMessage.new(contact.errors.full_messages, 422)), status: :unprocessable_entity
          end
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new("Company not found", 404)), status: :not_found
        end
      end

      def show
        authorize @current_user
        
        if !(contact = Contact.find_by(id: params[:id], user_id: params[:user_id]))
          render json: ErrorSerializer.format_error(ErrorMessage.new("Contact not found", 404)), status: :not_found
        else
          render json: ContactsSerializer.new(contact), status: :ok
        end
      end

      def update
        contact = Contact.find_by(id: params[:id], user_id: @current_user.id)

        if contact.nil?
          render json: ErrorSerializer.format_error(ErrorMessage.new("Contact not found", 404)), status: :not_found
          return
        end

        authorize contact

        if contact.update_contact(contact_params)
          render json: ContactsSerializer.new(contact), status: :ok
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new(error_messages, 422)), status: :unprocessable_entity
        end
      end

      def destroy
        contact = Contact.find_by(id: params[:id], user_id: @current_user.id)

        if contact.nil?
          skip_authorization
          render json: ErrorSerializer.format_error(ErrorMessage.new("Contact not found or unauthorized access", 404)), status: :not_found
          return
        end

        authorize contact

        if contact.destroy
          render json: { message: "Contact deleted successfully" }, status: :ok
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new("Failed to delete contact", 422)), status: :unprocessable_entity
        end
      end

      private

      def contact_params
        params.require(:contact).permit(:first_name, :last_name, :company_id, :email, :phone_number, :notes)
      end
    end
  end
end
