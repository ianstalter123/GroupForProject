class ArticlesController < ApplicationController

  def index
    @user = User.find_by_id(session[:user_id])
  	@articles = Article.all
  end

  def show
  	@article = Article.find_by_id(params[:id])
  end
  
  def new
   	@user = User.find_by_id(session[:user_id])
  	@article = @user.articles.new 
  end

  def create
    @user = User.find_by_id(session[:user_id])
   	@article = @user.articles.create article_params
    if @article
      ChartsWorker.perform_async(@article.id)
      redirect_to user_articles_path(session[:user_id]), flash: {success: "Created!"}
    else
      redirect_to new_user_article_path, flash: {error: @article.errors.full_messages}
    end
  end

  def compare
    @user = User.find_by_id(session[:user_id])
    @articles = Article.find(params[:article_ids])
    @score = 0
    @articles.each do |article|
      @score += article.score.to_f
    end
    @score /= @articles.length
  end

  def crawl
    @user = User.find_by_id(session[:user_id])
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
        @article = @user.articles.create(url: result['url'])
      else
         
      @article = @user.articles.create(url: "http://www.cnn.com/" + result['url'])
      if @article
        ChartsWorker.perform_async(@article.id)
        end
       end
     end
     redirect_to user_articles_path(session[:user_id])

  # request = doc.get(page, :headers=>{"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.125 Safari/537.36"})
   
 


   
   
    # @l = doc1.css("h3[class='title'] a").map { |link| link['href'] }
    # @l.each do |link|
    #     @article = @user.articles.create(url: link)
    #     if @article
    #     ChartsWorker.perform_async(@article.id)
    #     end
    #    end
    #  redirect_to user_articles_path(session[:user_id])

    #first just get a google search result page of links with ruby.
    #for each result link create an article
  #goal: get a google page of results
  #goal: get a list of links from the results
  #goal: create a new article using above methods from each result
  #goal: check to see if an article content is blank on create and 
         #delete if so




  end

  def destroy
    @article = Article.find_by_id(params[:id])
    @article.destroy
        redirect_to user_articles_path(session[:user_id]), alert: "Article destroyed!"
  end
  
  private
    def article_params
      params.require(:article).permit(:url, :title, :text, :author, :source, :date_published, :user_id)
    end

end
