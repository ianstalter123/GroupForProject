class TopicsController < ApplicationController


	def new
  	@topic = Topic.new 
  end

  def create
   
   	@topic = Topic.create topic_params
    if @topic
      redirect_to articles_path, flash: {success: "Created!"}
    else
      redirect_to new_topic_path, flash: {error: @article.errors.full_messages}
    end
  end

	def show
		@topic = Topic.find_by_id(params[:id])
		@articles = @topic.articles
		 @article_hash = {}
    @articles.each do |article|
      if article[:date_published]
        @article_hash[article[:date_published]] = article[:score]
      end  
    end 
	end

	def crawl
    @user = User.find_by_id(session[:user_id])
    @topic_id = params[:t]
    @topic = Topic.find_by_id(@topic_id)
    x = params[:q]
    url = x
     doc = Mechanize.new
      
    
    # # doc.get("http://www.msnbc.com/")
    # doc.get("http://www.cnn.com/")
    # doc.page.forms

    # #yahoo form = doc.page.forms.first
    # form = doc.page.form("headerSearch")

    # #yahoo form.p = x

    # form.fields[0].value = x
    # y = form.submit
    # doc1 = Nokogiri::HTML(doc.page.body)
    # binding.pry

    
    # doc.page.links
    # for cnn break it down to get individual articles
    #need 2check for an empty article and remove if blank!

    page = "http://searchapp.cnn.com/search/query.jsp?page=1&npp=10&start=1&text=" + url + "&type=all&bucket=true&sort=relevance&csiID=csi1"
    require 'open-uri'
    page = URI.escape(page)
    page = page.gsub(/%20/, '%2B')
   

    doc = Nokogiri::HTML(open(page).read)
    x = JSON.parse doc.css("textarea").text

    x['results'][0].each do |result|
      

      if result['url'].starts_with? 'http://', 'https://'
        @article = @topic.articles.create(url: result['url'])
      else
         
      @article = @topic.articles.create(url: "http://www.cnn.com/" + result['url'])
      if @article
        ChartsWorker.perform_async(@article.id)
        end
       end
   
   
     page1 = "http://www.msnbc.com/search/" + url
     doc1 = Nokogiri::HTML(open(page1).read)
     y = doc1.css(".search-result__teaser__title__link")
     
    y.each do |result|
    	 @article = @topic.articles.create(url: "http://www.msnbc.com" + result.attr('href'))
     	
      if @article
        ChartsWorker.perform_async(@article.id)
        end
       end
    end



     redirect_to topic_path(@topic)

  end

  private
    def topic_params
      params.require(:topic).permit(:title)
    end

end
