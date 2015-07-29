class Sentiment < ActiveRecord::Base
		has_one :article
end
