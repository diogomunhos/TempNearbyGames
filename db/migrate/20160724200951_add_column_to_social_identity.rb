class AddColumnToSocialIdentity < ActiveRecord::Migration
  def change
  	add_column :social_identities, :image_url, :string
  end
end
