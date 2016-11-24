class UserPreference < ActiveRecord::Base
	belongs_to :user, foreign_key: :user_id

	def self.find_by_user_id_cached(userid)
	  Rails.cache.fetch("find_by_user_id_#{userid}") { find_by_user_id(userid) }
	end
end