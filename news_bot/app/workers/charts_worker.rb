class	ChartsWorker
	include Sidekiq::Worker

	def perform(article_id)
		article = Article.find_by_id(article_id)
		# article.save_content
		article.save_context
    article.save_keywords
    article.save_sentiment
	end
end		