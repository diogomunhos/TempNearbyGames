class SocialMedia < ActiveRecord::Base
	self.table_name = "social_medias"
	has_many :social_articles, foreign_key: :social_media_id, dependent: :destroy

	scope :getSocialMediaPaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('name') }
end