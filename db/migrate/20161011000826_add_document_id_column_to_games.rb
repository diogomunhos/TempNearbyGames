class AddDocumentIdColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :document_id, :integer
  end
end