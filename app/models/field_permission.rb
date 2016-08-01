class FieldPermission < ActiveRecord::Base
	belongs_to :object_permission, foreign_key: :object_permission_id

end