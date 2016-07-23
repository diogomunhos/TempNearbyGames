class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
    	t.boolean :email_content
    	t.datetime :accepted_terms_date
    	t.integer :user_id
    end
  end
end
