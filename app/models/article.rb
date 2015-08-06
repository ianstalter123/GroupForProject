class Article < ActiveRecord::Base
	belongs_to :user

     validates :url, presence: true
     has_many :contexts
     has_many :keywords

     puts "*"*100

     def self.this_shit(someurl)
       encodedshit = URI.encode(someurl)
       url = URI.parse("http://api.diffbot.com/v3/article?token=#{ENV['DIFFBOT_KEY']}&url=#{encodedshit}")
       req = Net::HTTP::Get.new(url.to_s)
       res = Net::HTTP.start(url.host, url.port) {|http|
       http.request(req)
       }

       diffbot_hash = JSON.parse(res.body)

       puts 
       if diffbot_hash['error']
          self.dieeeeee
     end
     end

	# 'http://www.foxnews.com/us/2015/08/04/suspect-memphis-police-officer-killed-charged-murder/?intcmp=hpbt2'
     # "http://www.bbc.com/culture/story/20150804-comedy-in-the-age-of-outrage-when-jokes-go-too-far"
     # "http://www.foxnews.com/us/2015/08/04/suspect-memphis-police-officer-killed-charged-murder/"

     def save_content
          diffbotkey1 = ENV['DIFFBOT_KEY']
          url = URI.parse("http://api.diffbot.com/v3/article?token=#{diffbotkey1}&url=#{self.url}")
          req = Net::HTTP::Get.new(url.to_s)
          res = Net::HTTP.start(url.host, url.port) {|http|
               http.request(req)
          }
          diffbot_hash = JSON.parse(res.body)
          text      = diffbot_hash["objects"][0]["text"]
          source    = diffbot_hash["objects"][0]["siteName"]  
          image     = diffbot_hash["objects"][0]["images"][0]["url"]
          title     = diffbot_hash["objects"][0]["title"]
          # author may not work everytime
          author    = diffbot_hash["objects"][0]["author"]
          date      = diffbot_hash["objects"][0]["date"] 
     
          unless date
               date = diffbot_hash["objects"][0]["estimatedDate"]     
          end  
        
          self.update(raw_html: raw_html, text: text, author: author, title: title, date_published: date, image: image, source: source)
          

	end

     def save_sentiment
          AlchemyAPI.key = ENV['ALCHEMY_KEY']
          sentiments_api = AlchemyAPI.search(:sentiment_analysis, text: self.text)
          score = sentiments_api["score"].to_f
          relevance = sentiments_api["type"]
          self.update(score: score, relevance: relevance)
     end

     def save_context
          AlchemyAPI.key = ENV['ALCHEMY_KEY']
          context_api = AlchemyAPI.search(:concept_tagging, text: self.text)
          context_api.each do |c|
               relevance = c["relevance"].to_f
               text = c["text"]
               self.contexts.create(text: text, relevance: relevance)
          end
     end

     def save_keywords
          AlchemyAPI.key = ENV['ALCHEMY_KEY']
          keywords_api = AlchemyAPI.search(:keyword_extraction, text: self.text)
          keywords_api.each do |d|
               relevance = d["relevance"].to_f
               text = d["text"]
               self.keywords.create(text: text, relevance: relevance)
          end
     end
end
