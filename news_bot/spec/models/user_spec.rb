require 'rails_helper'

describe User do 	
	it {is_expected.to respond_to :email}
	it {is_expected.to respond_to :password}
	it {is_expected.to respond_to :password_digest}

	describe "when email is blank" do
		it "should not be valid" do
			user = User.create(
				email: "",
				password: "something",
				password_confirmation: "something")
			expect(user).to_not be_valid
		end
	end

	describe "when email is present" do
		it "should be valid" do
			user = User.create(
				email: "someone",
				password: "something",
				password_confirmation: "something")
			expect(user).to be_valid
		end		
	end

	describe "when the password is less than 8 characters" do
		it "should not be valid" do
			user = User.create(
				email: "someone",
				password: "2short",
				password_confirmation: "2short")
			expect(user).to_not be_valid
		end		
	end

end



	