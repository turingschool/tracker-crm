require 'rails_helper'

RSpec.describe AnswerFeedback, type: :model do
    describe 'associations' do
        it { should belong_to(:interview_question) }
    end
end