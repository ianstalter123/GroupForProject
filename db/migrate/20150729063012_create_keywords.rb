class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.float :relevance
      t.text :text
      t.string :article_id

      t.timestamps null: false
    end
  end
end
