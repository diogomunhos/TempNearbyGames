class CreateLoginsHistory < ActiveRecord::Migration
  def change
    create_table :login_histories do |t|
    	t.string :device
    	t.boolean :is_success
    	t.integer :user_id
    	t.timestamps
    end
  end
end
