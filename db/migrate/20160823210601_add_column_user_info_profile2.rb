class AddColumnUserInfoProfile2 < ActiveRecord::Migration
  def change
  	 add_column :user_preferences, :about, :string
  end
end
