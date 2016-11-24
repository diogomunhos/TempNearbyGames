class SocialIdentity < ActiveRecord::Base
	belongs_to :user

	validates :uid, :uniqueness => {:case_sensitive => false, :message => "Uid Already been used by another provider"},
			        :presence => {:message => "uid is required"}
	validates :provider, :presence => {:message => "Provider is required"}

	scope :updateUserId, -> (user_id = nil, uid = nil, provider = nil, id = nil) { where("uid=? AND provider=?", uid, provider).limit(1).update(id, user_id: user_id) }

	def self.find_for_oauth(auth)
		where(uid: auth.uid, provider: auth.provider).first_or_create do |social|
			social.uid = auth.uid
			social.provider = auth.provider
		end
	end

	def self.updateUserId_cached(user_id, uid, provider, id)
	  Rails.cache.fetch("updateUserId_#{user_id}_#{uid}_#{provider}_#{id}") { updateUserId(user_id, uid, provider, id) }
	end
end