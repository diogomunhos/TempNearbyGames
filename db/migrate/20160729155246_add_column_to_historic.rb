class AddColumnToHistoric < ActiveRecord::Migration
  def change
  	add_column :historics, :user_id, :integer
  end
end
