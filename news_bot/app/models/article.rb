class Article < ActiveRecord::Base

	belongs_to :user

	 def save_content
          url = self.url
          raw_html = Nokogiri::HTML(Typhoeus.get(self.url).response_body)
          
          if self.source == "Huffington Post"
               text = raw_html.css('.entry-component__content p').text
               author = raw_html.css('.author-component__name').text
               self.update(raw_html: raw_html, text: text,author: author)
          elsif self.source == "Fox"
               text = raw_html.css("div[itemprop='articleBody']").text 
               title = raw_html.css("h1[itemprop='headline']").text 
               date = raw_html.css("time[itemprop='datePublished']").text 
               author = raw_html.css("span[itemprop='name']").text 
               image = raw_html.css("div.m img").attr('src').value
               self.update(raw_html: raw_html, text: text,author: author, title: title, date_published: date, image: image)
          elsif self.source == "CNN"
               text = raw_html.css("div[itemprop='articleBody']").text 
               title = raw_html.css("h1[class='pg-headline']").text 
               date = raw_html.css("p[class='update-time']").text 
               author = raw_html.css("span[class='metadata__byline__author']").text 
               self.update(raw_html: raw_html, text: text,author: author, title: title, date_published: date)
          elsif self.source == "BBC News"
               title = raw_html.css('title').text
               text = raw_html.css('div.story-body__inner p').text
               date = raw_html.css("div.date").attr('data-datetime').value
               author = raw_html.css("meta[property = 'og:article:author']").attr('content').value
               self.update(raw_html: raw_html, text: text,author: author, title: title, date_published: date, image: image)
          end	
	 end
end
