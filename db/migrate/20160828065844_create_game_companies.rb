class CreateGameCompanies < ActiveRecord::Migration
  def change
    create_table :game_companies do |t|
      t.integer :game_id
      t.integer :company_id
      t.string :type

      t.timestamps
    end
  end
end
