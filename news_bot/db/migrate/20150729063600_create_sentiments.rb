class CreateSentiments < ActiveRecord::Migration
  def change
    create_table :sentiments do |t|
      t.float :score
      t.text :type
      t.string :article_id


      t.timestamps null: false
    end
  end
end
