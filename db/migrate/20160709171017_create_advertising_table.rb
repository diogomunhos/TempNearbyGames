class CreateAdvertisingTable < ActiveRecord::Migration
  def change
    create_table :advertisings do |t|
    	t.boolean :is_active
    	t.string :advertising_type
    	t.integer :position
    	t.string :html_body
    	t.string :tags
    	t.integer :quantity
    	t.string :pages
    	t.boolean :is_default

    	t.timestamps
    end
  end
end
