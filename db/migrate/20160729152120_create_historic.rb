class CreateHistoric < ActiveRecord::Migration
  def change
    create_table :historics do |t|
    	t.string :entity
    	t.string :changes
    	t.timestamps
    end
  end
end
