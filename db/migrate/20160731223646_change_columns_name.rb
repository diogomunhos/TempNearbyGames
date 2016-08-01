class ChangeColumnsName < ActiveRecord::Migration
  def change
  	rename_column :object_permissions, :delete, :delete_record
  	rename_column :object_permissions, :create, :create_record
  	rename_column :object_permissions, :read, :read_record
  	rename_column :object_permissions, :read_all, :read_all_record
  	rename_column :object_permissions, :edit, :edit_record
  	rename_column :object_permissions, :approve, :approve_record
  	remove_column :field_permissions, :delete
  	remove_column :field_permissions, :create
  	rename_column :field_permissions, :read, :read_record
  	rename_column :field_permissions, :edit, :edit_record
  end
end
