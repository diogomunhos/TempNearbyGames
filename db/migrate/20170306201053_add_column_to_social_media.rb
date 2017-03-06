class AddColumnToSocialMedia < ActiveRecord::Migration
  def change
  	add_column :social_medias, :media_api, :string
  end
end
