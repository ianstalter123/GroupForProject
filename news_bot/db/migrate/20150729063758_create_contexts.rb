class CreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.float :relevance
      t.text :text
      t.string :article_id


      t.timestamps null: false
    end
  end
end
