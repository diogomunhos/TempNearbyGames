class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |g|
      g.string :name
      g.date :release_date
      g.string :platform
      g.integer :wahiga_rating
      g.integer :user_rating
      g.string :description
      g.string :genre

      g.timestamps
    end
  end
end
