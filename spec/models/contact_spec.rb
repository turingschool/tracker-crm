require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "validations" do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  it { should belong_to(:user) }
  end
end
