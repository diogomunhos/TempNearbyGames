class AddTimeStamps < ActiveRecord::Migration
  def change
  	add_timestamps :social_identities
  	add_timestamps :user_documents
  	add_timestamps :user_preferences
  end
end
