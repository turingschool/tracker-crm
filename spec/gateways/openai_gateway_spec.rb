require 'rails_helper'

RSpec.describe OpenaiGateway do
  # successful request with short description
  # successful request with long description
  # unsuccessful request

  beforeEach do
    @gateway = OpenaiGateway.new
  end

  # describe 'build_prompt' do
  #   xit 'builds a prompt with a valid job description' do
  #     @valid_description = "We're Hiring: Software Engineer (Remote)

  #     Tech Innovations Inc. is looking for a skilled Software Engineer to join our growing team! 🚀 If you're passionate about building scalable web applications and working with cutting-edge technologies, we want to hear from you.

  #     In this role, you'll collaborate with designers, product managers, and fellow engineers to develop and maintain high-quality applications. You'll write clean, maintainable code, participate in code reviews, and help troubleshoot and optimize performance.

  #     What We're Looking For:
  #     ✅ 2+ years of software development experience
  #     ✅ Proficiency in Ruby on Rails, JavaScript, or similar technologies
  #     ✅ Experience with relational databases (PostgreSQL, MySQL)
  #     ✅ Familiarity with front-end frameworks (React, Vue.js)
  #     ✅ Strong problem-solving and communication skills
  #     ✅ Ability to work in an agile environment

  #     Why Join Us?
  #     ✨ Competitive salary & equity options
  #     ✨ Flexible work hours & remote-friendly culture
  #     ✨ Health, dental, & vision insurance
  #     ✨ Professional development budget
  #     ✨ A collaborative, inclusive team environment

  #     If you're excited about building great products and working with a team that values innovation and impact, apply today!

  #     #Hiring #SoftwareEngineer #RemoteWork #TechCareers"

  #     gateway = OpenaiGateway.new
  #     expect(gateway.build_prompt(@valid_description)).to eq("Please generate 3 practice interview questions 
  #     based on the following job description: #{@valid_description}.
  #     ONLY return a JSON array of these questions")
  #   end
  # end

  # describe 'clean_prompt' do
  #   xit 'can return a chatgpt response as a ruby array' do
  #     #write yo test
  #   end
  # end

  describe 'generate_interview_questions' do
    xit 'can return a json response with an array of interview questions from openai based on a job description' do
      @valid_description = "We're Hiring: Software Engineer (Remote)

      Tech Innovations Inc. is looking for a skilled Software Engineer to join our growing team! 🚀 If you're passionate about building scalable web applications and working with cutting-edge technologies, we want to hear from you.

      In this role, you'll collaborate with designers, product managers, and fellow engineers to develop and maintain high-quality applications. You'll write clean, maintainable code, participate in code reviews, and help troubleshoot and optimize performance.

      What We're Looking For:
      ✅ 2+ years of software development experience
      ✅ Proficiency in Ruby on Rails, JavaScript, or similar technologies
      ✅ Experience with relational databases (PostgreSQL, MySQL)
      ✅ Familiarity with front-end frameworks (React, Vue.js)
      ✅ Strong problem-solving and communication skills
      ✅ Ability to work in an agile environment

      Why Join Us?
      ✨ Competitive salary & equity options
      ✨ Flexible work hours & remote-friendly culture
      ✨ Health, dental, & vision insurance
      ✨ Professional development budget
      ✨ A collaborative, inclusive team environment

      If you're excited about building great products and working with a team that values innovation and impact, apply today!

      #Hiring #SoftwareEngineer #RemoteWork #TechCareers"

      expect()
    end

    xit 'can handle openai returning an error' do

    end

  end
end