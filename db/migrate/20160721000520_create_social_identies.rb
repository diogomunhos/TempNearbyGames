class CreateSocialIdenties < ActiveRecord::Migration
  def change
    create_table :social_identities do |t|
    	t.string :uid
    	t.string :provider
    	t.integer :user_id
    end
  end
end
