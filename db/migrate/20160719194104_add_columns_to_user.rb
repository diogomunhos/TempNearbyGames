class AddColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :birthdate, :date
  end
end
