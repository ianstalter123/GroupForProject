require 'rails_helper'

describe Article do 	
	it {is_expected.to respond_to :title}
	it {is_expected.to respond_to :source}
	it {is_expected.to respond_to :author}

describe "when title is blank" do
		it "should not be valid" do
			article = Article.create(
				title: "",
				source: "something",
				author: "something")
			expect(article).to_not be_valid
		end
	end
	describe "when url is blank" do
		it "should not be valid" do
			article = Article.create(
				url: "",
				title: "something",
				source: "something",
				author: "something")
			expect(article).to_not be_valid
		end
	end
end