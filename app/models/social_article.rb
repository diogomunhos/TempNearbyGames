class SocialArticle < ActiveRecord::Base
	belongs_to :article, foreign_key: :article_id
	belongs_to :social_media, foreign_key: :social_media_id
	
end