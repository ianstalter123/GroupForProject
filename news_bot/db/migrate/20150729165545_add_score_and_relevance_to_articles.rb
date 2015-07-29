class AddScoreAndRelevanceToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :score, :float
		add_column :articles, :relevance, :text
  end
end
