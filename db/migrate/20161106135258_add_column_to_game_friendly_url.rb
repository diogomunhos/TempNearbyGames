class AddColumnToGameFriendlyUrl < ActiveRecord::Migration
  def change
  	add_column :games, :friendly_url, :string
  end
end
