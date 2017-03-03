class AddColumnToArticleTable < ActiveRecord::Migration
  def change
  	add_column :articles, :cinema_id, :integer
  end
end
