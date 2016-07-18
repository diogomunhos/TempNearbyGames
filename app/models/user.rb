class User < ActiveRecord::Base

	has_secure_password
	
	def self.from_omniauth(auth)
	    where(auth.slice(provider: auth.provider, uid: auth.uid)).first_or_create do |user|
	      user.provider = auth.provider
	      user.uid = auth.uid
	      user.name = auth.info.name
	      user.oauth_token = auth.credentials.token
	      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
	      user.url = auth_hash['info']['urls'][user.provider.capitalize]
	      user.save!
	    end
	end

end