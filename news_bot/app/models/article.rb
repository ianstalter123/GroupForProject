class Article < ActiveRecord::Base

	belongs_to :user

	 def save_content

          url = self.url

          raw_html = Nokogiri::HTML(Typhoeus.get(self.url).response_body)
          # logic
          # response = RestClient.get url, :user_agent => 'Chrome'
          # raw_html = Nokogiri::HTML(response)
          text = raw_html.css('.entry-component__content p').text
          author = raw_html.css('.author-component__name').text

       
          
          self.update(text: text,author: author)
        
     	
  			
	 end
end
