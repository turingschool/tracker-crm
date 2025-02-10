module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :authenticate_user

      def index
        companies = policy_scope(@current_user.companies)
        authorize companies
        if companies.empty?
          render json: { data: [], message: "No companies found" }
        else
          render json: CompanySerializer.new(companies)
        end
      end

      def create
        authorize Company
        company = @current_user.companies.build(company_params)
        if company.save
          render json: CompanySerializer.new(company), status: :created
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new(company.errors.full_messages.to_sentence, 422)), status: :unprocessable_entity
        end
      end

      def update
        company = @current_user.companies.find_by(id: params[:id])

        if company.nil?
          skip_authorization
          render json: ErrorSerializer.format_error(
            ErrorMessage.new("Company not found", 404)
          ), status: :not_found
          return
        end

        authorize company

        if company_params.empty?
          render json: ErrorSerializer.format_error(
            ErrorMessage.new("No updates provided", 400)
          ), status: :bad_request
          return
        end

        if company.update(company_params)
          render json: CompanySerializer.new(company), status: :ok
        else
          render json: ErrorSerializer.format_error(
            ErrorMessage.new(company.errors.full_messages.to_sentence, 422)
          ), status: :unprocessable_entity
        end
      end

      def destroy
        company = @current_user.companies.find_by(id: params[:id])
        if company.nil?
          skip_authorization
          return render json: { error: "Company not found" }, status: :not_found
        end
          authorize company 
          company.handle_deletion
          render json: { message: "Company successfully deleted" }, status: :ok
      end

      private

      def company_params
        params.permit(:name, :website, :street_address, :city, :state, :zip_code, :notes)
      end
    end
  end
end