class CreateArticlesTable < ActiveRecord::Migration
  
  def change
  	create_table :articles do |a|
  		a.string :title
  		a.string :body
  		a.string :subtitle
  		a.string :preview
  		a.string :article_type
  		a.boolean :is_highlight
      a.string :tags
      a.string :friendly_url

  		a.timestamps
  	end

  end


end
