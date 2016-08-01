class ObjectPermission < ActiveRecord::Base
	has_many :field_permissions, foreign_key: :object_permission_id, dependent: :destroy
	belongs_to :profile, foreign_key: :profile_id

end