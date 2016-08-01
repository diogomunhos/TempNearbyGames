class AddColumnsToProfile < ActiveRecord::Migration
  def change
  	add_column :profiles, :active, :boolean
  	add_column :profiles, :created_by, :integer
  	add_column :profiles, :last_updated_by, :integer
  end
end
