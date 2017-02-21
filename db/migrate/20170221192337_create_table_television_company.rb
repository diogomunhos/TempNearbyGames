class CreateTableTelevisionCompany < ActiveRecord::Migration
  def change
    create_table :cinema_companies do |t|
    	t.integer  :cinema_id
	    t.integer  :company_id
	    t.string   :company_type
	    t.timestamps
    end
  end
end
