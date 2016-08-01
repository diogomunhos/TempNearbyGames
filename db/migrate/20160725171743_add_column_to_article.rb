class AddColumnToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :created_by_id, :integer
  	add_column :articles, :last_updated_by_id, :string
  	add_column :articles, :created_by_name, :string
  	add_column :articles, :last_updated_by_name, :string
  	add_column :articles, :status, :string
  end
end
