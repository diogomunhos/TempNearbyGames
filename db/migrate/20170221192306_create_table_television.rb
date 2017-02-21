class CreateTableTelevision < ActiveRecord::Migration
  def change
    create_table :cinemas do |t|
    	t.string :name
	    t.date   :release_date
	    t.string :type
	    t.decimal :wahiga_rating
	    t.decimal :user_rating
	    t.string  :description
	    t.string  :genre
	    t.integer :document_id
	    t.string  :friendly_url
	    t.string  :trailer
	    t.timestamps
    end
  end
end
