class User < ActiveRecord::Base
	before_create :confirmation_token

	validates :password, :confirmation => true
	validates :nickname, :uniqueness => {:case_sensitive => false, :message => "Email is already registered by another user, please choose another"}
	validates :email, :uniqueness => {:case_sensitive => false, :message => "Nickname is already registered by another user, please choose another"}

	has_one :user_preference, foreign_key: :user_id, dependent: :destroy

	scope :getUserByEmailOrNickname, -> (email = nil, nickname = nil) { where("email=? OR nickname=?", email, nickname)}	

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

	def email_activate
	    self.email_confirmed = true
	    self.confirm_token = nil
	    self.save
	end

	private
	def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end

end