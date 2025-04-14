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
        @user1 = create(:user)
        @user2 = create(:user)
      end

      it "allows duplicate names for different users" do
        contact = create(:contact, first_name: "John", last_name:"Smith", user: @user1)
        same_contact = create(:contact, first_name: "John", last_name: "Smith", user: @user2)

        expect(same_contact).to be_valid
      end

      it "allows duplicate names for same user" do
        contact = create(:contact, first_name: "Jack", last_name:"Frost", user: @user1)
        duplicate_contact = create(:contact, first_name: "Jack", last_name: "Frost", user: @user2)

        expect(duplicate_contact).to be_valid
      end

      xit "is valid with a company" do
        company = Company.create!(
          name: "Turing", 
          website: "www.turing.com", 
          street_address: "123 Main St",
          city: "Denver",
          state: "CO",
          zip_code: "80218",
          user: @user1)
        contact = Contact.create!(first_name: "John", last_name: "Smith", user: @user1, company: company)
        expect(contact).to be_valid
      end

      xit "is valid without a company" do
        contact = Contact.create!(first_name: "John", last_name: "Smith", user: @user1)
        expect(contact).to be_valid
      end
    end

    context "phone number validations" do
      before(:each) do
        @user1 = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
      end

      xit "is valid with a properly formatted phone number" do
        valid_numbers = ["123-456-7890", "555-555-5555", "720-555-5555"]
        valid_numbers.each do |number|
        contact = Contact.new(
          first_name: "John",
          last_name: "Smith",
          phone_number: number,
          user: @user1
        )
        expect(contact).to be_valid
        end
      end

      xit "is invalid with an improperly formatted phone number" do
        invalid_numbers = ["1234567890", "555555-5555", "(555)555-5555", "555)555-5555"]
        invalid_numbers.each do |number|
          contact = Contact.new(
          first_name: "John",
          last_name: "Smith",
          phone_number: number,
          user: @user1
        )
          expect(contact).not_to be_valid
          expect(contact.errors[:phone_number]).to include("must be in the format '555-555-5555'")
        end
      end

      xit "is valid if phone number is blank" do
        contact = Contact.create!(
          first_name: "John",
          last_name: "Smith",
          phone_number: "",
          user: @user1
        )
        expect(contact).to be_valid
        end
      end

    context "email validations" do
      before(:each) do
        @user1 = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
      end

      xit "is valid with a properly formatted email" do
        valid_emails = ["turing@gmail.com", "turing@edu.com", "turing123@msn.com", "turing@edu123.co"]
        valid_emails.each do |email|
        contact = Contact.new(
          first_name: "John",
          last_name: "Jacob",
          email: email,
          user: @user1
        )
        expect(contact).to be_valid
        end
      end

      xit "is invalid with an improperly formatted email" do
        invalid_emails = ["goodplace", "jki@msn.", "gmail.com", "user@@gmail.com"]
        invalid_emails.each do |email|
          contact = Contact.new(
          first_name: "John",
          last_name: "Smith",
          email: email,
          user: @user1
        )
          expect(contact).not_to be_valid
          expect(contact.errors[:email]).to include("must be a valid email address")
        end
      end

      xit "is valid if email is blank" do
        contact = Contact.create!(
          first_name: "John",
          last_name: "Smith",
          email: "",
          user: @user1
        )
        expect(contact).to be_valid
      end
    end

    context "dependent destroy" do
      before(:each) do
        @user = User.create!(name: "Johnte", email: "jsmith@hotmail.com", password: "st#nGP@ss")
        @company = Company.create!(
          name: "Turing",
          website: "www.turing.edu",
          street_address: "555 Main",
          city: "Denver",
          state: "CO",
          zip_code: "80222",
          user: @user
        )
        @contact1 = Contact.create!(first_name: "John", last_name: "Smith", user: @user, company: @company)
        @contact2 = Contact.create!(first_name: "Jane", last_name: "Doe", user: @user)

        xit "destroys contacts when the user is deleted" do
          expect { @user.destroy }.to change { Contact.count }.by(-2)
        end
      end
    end

  describe "#update_contact" do
    before(:each) do
      @user = User.create!(name: "Me", email: "its_me@example.com", password: "reallyGoodPass")
      @company = Company.create!(
        name: "Turing",
        website: "www.turing.com",
        street_address: "123 Main St",
        city: "Denver",
        state: "CO",
        zip_code: "80218",
        user: @user
      )
      @contact = Contact.create!(
        first_name: "John",
        last_name: "Smith",
        email: "john@example.com",
        phone_number: "555-555-5555",
        user: @user,
        company: @company
      )
    end

    context "Happy Paths" do
      xit "successfully updates a contact's email" do
        expect(@contact.update_contact(email: "new_email@example.com")).to be_truthy
        expect(@contact.reload.email).to eq("new_email@example.com")
      end

      xit "successfully updates a contact's phone number" do
        expect(@contact.update_contact(phone_number: "123-456-7890")).to be_truthy
        expect(@contact.reload.phone_number).to eq("123-456-7890")
      end

      xit "allows updating multiple fields at once" do
        update_params = { first_name: "Jane", last_name: "Doe", email: "jane@example.com" }
        expect(@contact.update_contact(update_params)).to be_truthy
        expect(@contact.reload.first_name).to eq("Jane")
        expect(@contact.reload.last_name).to eq("Doe")
        expect(@contact.reload.email).to eq("jane@example.com")
      end
    end

    context "Sad Paths" do
      xit "fails to update if the phone number format is invalid" do
        expect(@contact.update_contact(phone_number: "1234567890")).to be_falsey
        expect(@contact.errors[:phone_number]).to include("must be in the format '555-555-5555'")
      end

      xit "fails to update if the email format is invalid" do
        expect(@contact.update_contact(email: "invalid-email")).to be_falsey
        expect(@contact.errors[:email]).to include("must be a valid email address")
      end
    end

    context "Edge Cases" do
      xit "does not change attributes if no updates are provided" do
        expect(@contact.update_contact({})).to be_truthy
        expect(@contact.reload.first_name).to eq("John")
        expect(@contact.reload.last_name).to eq("Smith")
      end

      xit "partially updates only the provided fields" do
        @contact.update_contact(first_name: "Updated")
        expect(@contact.reload.first_name).to eq("Updated")
        expect(@contact.reload.last_name).to eq("Smith")
      end
    end
  end
end
end