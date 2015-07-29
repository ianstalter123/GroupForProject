class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :source
      t.string :author
      t.string :date_published
      t.string :location
      t.text :text
      t.string :url
      t.string :user_id

      t.timestamps null: false
    end
  end
end


<%= link_to "", _path %>