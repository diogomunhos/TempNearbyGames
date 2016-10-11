class RenameGameCompanyColumn < ActiveRecord::Migration
  def change
  	rename_column :game_companies, :type, :company_type
  end
end
