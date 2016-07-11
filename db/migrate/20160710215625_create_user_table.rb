class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.string :last_name
    	t.string :email, unique: true
    	t.string :nickname
    	t.integer :profile_id
    	t.integer :role_id
    	t.string :password
    	t.string :password_confirmation
    	t.string :password_digest

    	t.timestamps
    end
  end
end
