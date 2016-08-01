class AddColumnsToHistoric < ActiveRecord::Migration
  def change
  	add_column :historics, :object_id, :integer
  end
end
