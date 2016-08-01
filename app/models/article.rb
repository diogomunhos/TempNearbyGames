class Article < ActiveRecord::Base
	has_many :article_documents, foreign_key: :article_id, dependent: :destroy
	has_many :documents, through: :article_documents
	#relation with user on created_by_id

	validates :friendly_url, :uniqueness => {:case_sensitive => false, :message => "Friendly URL is already registered by another article, please choose another"},
							 :format => { without: /\s/, :message => "Friendly URL dont permit white spaces" }

	scope :getLast10Articles, -> (slider = nil, highlight = nil) { where.not(id: slider).where.not(id: highlight).order('created_at desc').limit(10).includes(:documents) }	
	scope :getLast3ArticlesSlider, -> { where(is_highlight: true).order('created_at desc').limit(3).includes(:documents) }
	scope :getLast4HighlightedArticles, -> (slider = nil) { where(is_highlight: true).where.not(id: slider).order('created_at desc').limit(4).includes(:documents)}
	scope :getArticleWithDocumentsById, -> (article_id = nil) { where(id: article_id).limit(1).includes(:documents) }
	scope :getArticlePaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllArticlesSearchByField, -> (fieldToSearch = nil, searchValue = nil, numberPerPage = nil, offset_page = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllArticlesSearchByFieldCount, -> (fieldToSearch = nil, searchValue = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").count }

end