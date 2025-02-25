require 'rails_helper'

RSpec.describe OpenaiGateway do
  before :each do
    @gateway = OpenaiGateway.new
    @valid_description = "We're Hiring: Software Engineer (Remote)

    Tech Innovations Inc. is looking for a skilled Software Engineer to join our growing team! 🚀 If you're passionate about building scalable web applications and working with cutting-edge technologies, we want to hear from you.

    In this role, you'll collaborate with designers, product managers, and fellow engineers to develop and maintain high-quality applications. You'll write clean, maintainable code, participate in code reviews, and help troubleshoot and optimize performance."

  end

  describe 'generate_interview_questions' do
    it 'returns a JSON response with an array of interview questions from OpenAI based on a job description' do

      VCR.use_cassette("openai_gateway_success") do
        gateway_response = @gateway.generate_interview_questions(@valid_description)
        expect(gateway_response[:success]).to eq(true)
        expect(gateway_response[:id]).to be_present
        expect(gateway_response[:data].size).to eq(3)
        expect(gateway_response[:data][0]).to eq("Can you describe your experience with building scalable web applications and the technologies you have used in your previous projects?")
        expect(gateway_response[:data][1]).to eq("How do you approach code reviews, and what specific practices do you follow to ensure code quality and maintainability?")
        expect(gateway_response[:data][2]).to eq("Can you provide an example of a time when you had to troubleshoot a performance issue in an application? What steps did you take to identify and resolve the problem?")
      end
    end

    it 'can handle openai returning an error' do

      VCR.use_cassette("openai_gateway_failure") do
        gateway_response = @gateway.generate_interview_questions(@valid_description)
        expect(gateway_response[:success]).to eq(false)
        expect(gateway_response[:error]).to eq("Failed to fetch interview questions.")
      end
    end

    it 'can handle openai returning an unexpected format' do
    
      VCR.use_cassette("openai_gateway_success_formatting_issue") do
        gateway_response = @gateway.generate_interview_questions(@valid_description)
        expect(gateway_response[:success]).to eq(false)
        expect(gateway_response[:error]).to eq("Unexpected response format from OpenAI.")

      end
    end

    it 'can handle openai returning an unexpected error' do
      allow(Faraday).to receive(:post).and_raise(StandardError.new("Something went wrong"))

      response = @gateway.generate_interview_questions(@valid_description)

      expect(response[:success]).to eq(false)
      expect(response[:error]).to include("An error occurred: Something went wrong")
    end

  end
end