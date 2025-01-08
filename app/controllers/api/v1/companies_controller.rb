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

      private

      def company_params
        params.permit(:name, :website, :street_address, :city, :state, :zip_code, :notes)
      end
    end
  end
end