class CreateObjectsPermission < ActiveRecord::Migration
  def change
    create_table :objects_permissions do |t|
    	t.string :object_name
    	t.boolean :read
    	t.boolean :create
    	t.boolean :edit
    	t.boolean :delete
    	t.boolean :read_all
    	t.boolean :approve
    	t.integer :profile_id
    	t.timestamps
    	t.integer :last_updated_by
    end
  end
end
