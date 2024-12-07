require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company).optional }

  end

  describe "validations" do  
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    
    context "custom validations" do
      before(:each) do
        @user1 = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
        @user2 = User.create!(name: "Mary", email: "email", password: "Password")
      end

      it "is not valid without a unique first_name and last_name for the same user" do
        Contact.create!(first_name: "John", last_name: "Smith", user: @user1)
        duplicate_contact = Contact.new(first_name: "John", last_name: "Smith", user: @user1)

        expect(duplicate_contact).not_to be_valid
        expect(duplicate_contact.errors[:first_name]).to include("and Last name already exist for this user")
      end

      it "is valid with a unique first_name and last_name for the same user" do
        Contact.create!(first_name: "John", last_name: "Smith", user: @user1)
        unique_contact = Contact.new(first_name: "Jane", last_name: "Smith", user: @user1)

        expect(unique_contact).to be_valid
      end

      it "allows duplicate names for different users" do
        contact = Contact.create!(first_name: "John", last_name: "Smith", user: @user1)
        same_contact = Contact.new(first_name: "John", last_name: "Smith", user: @user2)

        expect(same_contact).to be_valid
      end

      it "is valid without a company" do
        contact = Contact.new(first_name: "John", last_name: "Smith", user: @user1)
        expect(contact).to be_valid
      end

      it "is valid with a company" do
        company = Company.create!(
          name: "Turing", 
          website: "www.turing.com", 
          street_address: "123 Main St",
          city: "Denver",
          state: "CO",
          zip_code: "80218",
          user: @user1)
        contact = Contact.new(first_name: "John", last_name: "Smith", user: @user1, company: company)
        expect(contact).to be_valid
      end
    end
  end
end
