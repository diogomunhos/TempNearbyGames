class ChangeColumnNameHistoric < ActiveRecord::Migration
  def change
  	rename_column :historics, :changes, :changed_fields
  end
end
