require 'rails_helper'

RSpec.describe AnswerFeedback, type: :model do
  describe "associations" do
    it { should belong_to(:interview_question) }
  end

  describe "validations" do
    it { should validate_presence_of(:answer) }
    it { should validate_presence_of(:feedback) }
  end
end