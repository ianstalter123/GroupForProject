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
				email: "someone@gmail.com",
				password: "something",
				password_confirmation: "something")
			expect(user).to be_valid
		end		
	end

	describe "when email does not have an @ sign" do
		it "should not be valid" do
			user = User.create(
				email: "someonegmailcom",
				password: "something",
				password_confirmation: "something")
			expect(user).to_not be_valid
		end		
	end

	describe "when email has an @ sign" do
		it "should be valid" do
			user = User.create(
				email: "someone@gmail.com",
				password: "something",
				password_confirmation: "something")
			expect(user).to be_valid
		end		
	end

	describe "when password is between 8 and 20 characters" do
		it "should be valid" do
			user = User.create(
				email: "someone@blah.edu",
				password: "validpassword",
				password_confirmation: "validpassword")
			expect(user).to be_valid
		end		
	end

	describe "when the password is less than 8 characters" do
		it "should not be valid" do
			user = User.create(
				email: "someone@gmail.com",
				password: "2short",
				password_confirmation: "2short")
			expect(user).to_not be_valid
		end		
	end

	describe "when the password is more than 20 characters" do
		it "should not be valid" do
			user = User.create(
				email: "someone@gmail.com",
				password: "thispasswordisgoingtobetoolong",
				password_confirmation: "thispasswordisgoingtobetoolong")
			expect(user).to_not be_valid
		end		
	end

	describe "when password and password_confirmation are not the same" do
		it "should not be valid" do
			user = User.create(
				email: "someone@gmail.com",
				password: "thisdoesntmatch",
				password_confirmation: "thisone")
			expect(user).to_not be_valid
		end		
	end

	describe "when password and password_confirmation are the same" do
		it "should be valid" do
			user = User.create(
				email: "someone@gmail.com",
				password: "thismatches",
				password_confirmation: "thismatches")
			expect(user).to be_valid
		end		
	end



end



	