module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :authenticate_user

      def index
        if @current_user.nil?
          render json: { error: "Not authenticated" }, status: :unauthorized
          return
        end
        
        companies = @current_user.companies
        
        if companies.empty?
          render json: { data: [], message: "No companies found" }
        else
          render json: CompanySerializer.new(companies)
        end
      end

      def create
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

      def decoded_token(token)
        JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0].symbolize_keys
      end
    end
  end
end