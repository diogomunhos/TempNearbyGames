class Addfieldstoarticle < ActiveRecord::Migration
  def change
  	add_column :articles, :facebook_post_id, :string 

  end
end
