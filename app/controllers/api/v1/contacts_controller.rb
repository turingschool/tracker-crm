module Api
  module V1
    class ContactsController < ApplicationController
      before_action :authenticate_user

      def index
        if params[:company_id]
          company = @current_user.companies.find_by(id: params[:company_id])
          
          if company
            authorize company
            contacts = company.contacts
            render json: { company: CompanySerializer.new(company), contacts: ContactsSerializer.new(contacts) }
          else
            skip_authorization
            render json: { error: "Company not found or unauthorized access" }, status: :not_found
          end
        else
				  authorize Contact
          contacts = @current_user.contacts
          if contacts.empty?
            render json: { data: [], message: "No contacts found" }, status: :ok
          else
            render json: ContactsSerializer.new(contacts), status: :ok
          end
        end
      end

      def create 
        authorize Contact
        if params[:company_id] 
          company = @current_user.companies.find_by(id: params[:company_id])
          if company
            contact = company.contacts.new(contact_params.merge(user_id: @current_user.id))
          else
            return render json: { error: "Company not found" }, status: :not_found
          end
        else
          contact = @current_user.contacts.new(contact_params)
        end
        
        if contact.save
          render json: ContactsSerializer.new(contact), status: :created
        else
          render json: { error: contact.errors.full_messages.to_sentence }, status: :unprocessable_entity
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
