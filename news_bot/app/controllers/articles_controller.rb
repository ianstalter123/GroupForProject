class ArticlesController < ApplicationController

  def index
  	@articles = Article.all
  end

  def show
  	@article = Article.find_by_id(params[:id])
    # @articles = Article.all

    # series = []

    # @articles.each do |article|
    #   series << [article.date_published,article.title]
    # end
   

    # bubble_series = [[1,15], [2,6], [3,5], [4,9]]
    #   @chart = LazyHighCharts::HighChart.new('bubble') do |f|
    #     f.title(text: 'Bubbles!')            
    #     f.chart(type: 'line', zoomType: 'xy', plotBorderWidth: 1) 
    #     f.series(
    #       data: series,
    #       marker: {
    #         fillColor: {
    #           radialGradient: { cx: 0.4, cy: 0.3, r: 0.7 },
    #           stops: [ [0, 'rgba(255,255,255,0.5)'], [1, 'rgba(69,114,167,0.5)'] ]
    #        }
    #      }
    #    )
  # end
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
    @articles = Article.find(params[:article_ids])
  end
  
  private
    def article_params
      params.require(:article).permit(:url, :title, :text, :author, :source, :date_published, :user_id)
    end

end
