class ChangeColumnNameByCinema < ActiveRecord::Migration
  def change
  	rename_column :cinemas, :type, :cinema_type
  end
end
