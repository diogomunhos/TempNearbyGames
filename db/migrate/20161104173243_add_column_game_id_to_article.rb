class AddColumnGameIdToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :game_id, :integer
  end
end
