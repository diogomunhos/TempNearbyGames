class RenameTableObjectAndFieldPermissions < ActiveRecord::Migration
  def change
  	rename_table :objects_permissions, :object_permissions
  	rename_table :fields_permissions, :field_permissions
  end
end
