class User < ActiveRecord::Base
	has_many :user_documents, foreign_key: :user_id, dependent: :destroy
	has_many :documents, through: :user_documents
	has_one :user_login_info, foreign_key: :user_id, dependent: :destroy

	before_create :confirmation_token

	validates :password, :confirmation => true
	validates :nickname, :uniqueness => {:case_sensitive => false, :message => "Nickname já cadastrado"}, allow_blank: true
	validates :email, :uniqueness => {:case_sensitive => false, :message => "Email já cadastrado"}

	has_one :user_preference, foreign_key: :user_id, dependent: :destroy

	scope :getUserByEmailOrNickname, -> (email = nil, nickname = nil) { where("email=? OR nickname=?", email, nickname)}
	scope :getUserAndDocumentsByType, -> (user_id = nil, document_type = nil) {where("users.id=?", user_id).limit(1).includes(:documents).where('user_documents.document_type=?', document_type).references(:documents)}	
	scope :getUserPaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('name') } 
	
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

    def self.find_cached(id)
	  Rails.cache.fetch("find_#{id}") { find(id) }
	end

	def self.find_by_email_cached(email)
	  Rails.cache.fetch("find_by_email_#{email}") { find_by_email(email) }
	end

end