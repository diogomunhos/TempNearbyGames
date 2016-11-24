class Profile < ActiveRecord::Base
	has_many :object_permissions, foreign_key: :profile_id, dependent: :destroy

	
	validates :name, :uniqueness => {:case_sensitive => false, :message => "This name is already registered, please choose another"}

	scope :getProfilePaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('name') }

	def self.find_cached(id)
	  Rails.cache.fetch("find_#{id}") { find(id) }
	end
end