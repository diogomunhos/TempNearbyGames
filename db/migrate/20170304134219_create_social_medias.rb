class CreateSocialMedias < ActiveRecord::Migration
  def change
    create_table :social_medias do |t|
    	t.string :name
    	t.timestamps
    end
  end
end
