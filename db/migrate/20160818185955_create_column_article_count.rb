class CreateColumnArticleCount < ActiveRecord::Migration
  def change
    add_column :articles, :views, :integer
  end
end
