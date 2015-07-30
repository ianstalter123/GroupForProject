class Article < ActiveRecord::Base

	belongs_to :user
     validates :source, presence: true
     validates :url, presence: true
     has_many :contexts
     has_many :keywords

	def save_content
          AlchemyAPI.key = ENV['ALCHEMY_KEY']
          diffbotkey = '505a59ea9a6b764b0b8488dee266d5f9'

          url = URI.parse("http://api.diffbot.com/v3/article?token=" + diffbotkey + "&url=" + self.url)
          req = Net::HTTP::Get.new(url.to_s)
          res = Net::HTTP.start(url.host, url.port) {|http|
               http.request(req)
          }
          diffbot_hash = JSON.parse(res.body)
          
          text      = diffbot_hash["objects"][0]["text"]
          source    = diffbot_hash["objects"][0]["siteName"]  
          image     = diffbot_hash["objects"][0]["images"][0]["url"]
          title     = diffbot_hash["objects"][0]["title"]
          
          # author may not work
          author    = diffbot_hash["objects"][0]["author"]

          date      = diffbot_hash["objects"][0]["date"] 
          if !date
               date = diffbot_hash["objects"][0]["estimatedDate"]     
          end  
          self.update(raw_html: raw_html, text: text, author: author, title: title, date_published: date, image: image, source: source)

          

          # test_return = Typhoeus.get("http://api.diffbot.com/v3/article" self.url)

          binding.pry

          # text = AlchemyAPI.search(:text_extraction, url: self.url)
          # title = AlchemyAPI.search(:title_extraction, url: self.url)
          # author = AlchemyAPI.search(:author_extraction, url: self.url)
          # category = AlchemyAPI.search(:text_categorization, url: self.url)


          # url = self.url
          # raw_html = Nokogiri::HTML(Typhoeus.get(self.url).response_body)
          
          # if self.source == "Huffington Post"
          #      text = raw_html.css('.entry-component__content p').text
          #      author = raw_html.css('.author-component__name').text
          #      title = raw_html.css('.entry-component__headline').text
          #      date = raw_html.css('.entry-component__posted').text
          #      image = raw_html.css(".wrapper-component .image-component img")[0].attr("src")
          #      self.update(raw_html: raw_html, text: text, author: author, title: title, date_published: date, image: image)

          # elsif self.source == "Fox"
          #      text = raw_html.css("div[itemprop='articleBody']").text 
          #      title = raw_html.css("h1[itemprop='headline']").text 
          #      date = raw_html.css("time[itemprop='datePublished']").text 
          #      author = raw_html.css("span[itemprop='name']").text 
          #      image = raw_html.css("div.m img").attr('src').value
          #      self.update(raw_html: raw_html, text: text,author: author, title: title, date_published: date, image: image)
          # elsif self.source == "CNN"
          #      text = raw_html.css("div[itemprop='articleBody']").text 
          #      title = raw_html.css("h1[class='pg-headline']").text 
          #      date = raw_html.css("p[class='update-time']").text 
          #      author = raw_html.css("span[class='metadata__byline__author']").text 
          #      self.update(raw_html: raw_html, text: text,author: author, title: title, date_published: date, image: image)
          # elsif self.source == "BBC News"
          #      title = raw_html.css('title').text
          #      text = raw_html.css('div.story-body__inner p').text
          #      date = raw_html.css("div.date").attr('data-datetime').value
          #      author = raw_html.css("meta[property = 'og:article:author']").attr('content').value
          #      image = raw_html.css('figure.lead img').attr('src').value
          #      self.update(raw_html: raw_html, text: text,author: author, title: title, date_published: date, image: image)
          # end	
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
