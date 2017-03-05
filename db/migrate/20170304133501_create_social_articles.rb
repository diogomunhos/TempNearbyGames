class CreateSocialArticles < ActiveRecord::Migration
  def change
    create_table :social_articles do |t|
    	t.datetime :published_time
    	t.integer :social_media_id
    	t.string :published_id
    	t.string :status
    	t.string :title
    	t.string :subtitle
    	t.string :post_title
    	t.integer :document_id
    	t.integer :article_id
    	t.timestamps
    end
  end
end
