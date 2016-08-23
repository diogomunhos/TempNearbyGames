class AddColumnUserInfoProfile < ActiveRecord::Migration
  def change
  	 add_column :user_preferences, :facebook, :string
  	 add_column :user_preferences, :twitter, :string
  	 add_column :user_preferences, :instagram, :string
  end
end
