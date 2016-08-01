class CreateFieldsPermission < ActiveRecord::Migration
  def change
    create_table :fields_permissions do |t|
    	t.string :field_name
    	t.boolean :read
    	t.boolean :create
    	t.boolean :edit
    	t.boolean :delete
    	t.integer :object_permission_id
    	t.timestamps
    	t.integer :last_updated_by
    end
  end
end
