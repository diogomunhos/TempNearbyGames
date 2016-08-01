class Profile < ActiveRecord::Base
	has_many :object_permissions, foreign_key: :profile_id, dependent: :destroy

	
	validates :name, :uniqueness => {:case_sensitive => false, :message => "This name is already registered, please choose another"}
end