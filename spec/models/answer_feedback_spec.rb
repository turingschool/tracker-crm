require 'rails_helper'

RSpec.describe AnswerFeedback, type: :model do
    it { should belong_to(:interview_question) }
end