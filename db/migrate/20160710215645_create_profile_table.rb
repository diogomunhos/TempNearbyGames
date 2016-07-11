class CreateProfileTable < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.string :name

    	t.timestamps
    end
  end
end
