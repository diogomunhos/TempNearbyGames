class AddPlatformsToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :platform, :string
  	add_column :articles, :review_note, :string
  	add_column :articles, :release_date, :date
  end
end
