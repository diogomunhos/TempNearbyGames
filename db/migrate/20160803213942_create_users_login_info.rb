class CreateUsersLoginInfo < ActiveRecord::Migration
  def change
    create_table :user_login_infos do |t|
    	t.boolean :is_locked
    	t.string :reset_password_token
    	t.date :reset_request_date
    	t.integer :user_id
    	t.timestamps
    end
  end
end
