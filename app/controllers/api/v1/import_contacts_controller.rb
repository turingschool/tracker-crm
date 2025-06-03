module Api
  module V1
    class ImportContactsController < ApplicationController
      before_action :authenticate_user
      # before_action :set_user

      # def import
      #   contacts_params = params[:contacts]
      # end
      def create
        authorize Contact

        if !params[:contacts] || !params[:contacts].is_a?(Array)
          render json: ErrorSerializer.format_error(ErrorMessage.new("Invalid or missing contacts data", 400)), status: :bad_request
          return
        end

        imported_contacts = []
        failed_imports = []

        params[:contacts].each do |contact|
          permitted_data = contact.permit(:first_name, :last_name, :email, :phone_number, :notes, :company_id)

          if permitted_data["company_id"]
            company = Company.find_by(id: permitted_data["company_id"], user_id: @current_user.id)
            unless company
              failed_imports << { data: permitted_data, errors: ["Company not found"] }
              next
            end
          end

          contact = Contact.create_optional_company(permitted_data, @current_user.id, permitted_data["company_id"])

          if contact.persisted?
            imported_contacts << contact
          else
            failed_imports << { data: permitted_data, errors: contact.errors.full_messages }
          end
        end

        if imported_contacts.any?
          render json: {
            imported: ContactsSerializer.new(imported_contacts),
            imported_count: imported_contacts.size,
            failed: failed_imports,
            failed_count: failed_imports.size
          }, status: :created
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new("No contacts imported", 422)), status: :unprocessable_entity
        end
      end
    end
  end
end