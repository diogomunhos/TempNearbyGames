class ChangeGamesTable < ActiveRecord::Migration
  def change
  	add_column :games, :trailer, :string
  	change_column :games, :wahiga_rating, :decimal
  	change_column :games, :user_rating, :decimal
  end
end
