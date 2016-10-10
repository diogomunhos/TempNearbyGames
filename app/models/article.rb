class Article < ActiveRecord::Base
	has_many :article_documents, foreign_key: :article_id, dependent: :destroy
	has_many :documents, through: :article_documents
	#relation with user on created_by_id

	validates :friendly_url, :uniqueness => {:case_sensitive => false, :message => "Friendly URL is already registered by another article, please choose another"},
							 :format => { without: /\s/, :message => "Friendly URL dont permit white spaces" }

	scope :getLast10Articles, -> (slider = nil) { where.not(id: slider).where(status: "Published").order('created_at desc').limit(10).includes(:documents) }	
	scope :getLast4ArticlesSlider, -> { where(is_highlight: true).where(status: "Published").order('created_at desc').limit(4).includes(:documents) }
	scope :getArticleWithDocumentsById, -> (article_id = nil) { where(id: article_id).limit(1).includes(:documents) }
	scope :getArticlePaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllArticlesSearchByField, -> (fieldToSearch = nil, searchValue = nil, numberPerPage = nil, offset_page = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllArticlesSearchByFieldCount, -> (fieldToSearch = nil, searchValue = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").count }
	scope :get10MostPopularArticles, -> (id = nil) { where.not(id: id).where(status: "Published").limit(10).order("views DESC").includes(:documents)}
	scope :get3RandomArticles, -> (id = nil) {where.not(id: id).where(status: "Published").order("RANDOM()").limit(3).includes(:documents)}
	scope :get3RandomArticlesFromAuthor, -> (id = nil, author_id = nil) {where.not(id: id).where(status: "Published", created_by_id: author_id).order("RANDOM()").limit(3).includes(:documents)}
	scope :getArticleByPlatform, -> (platform = nil) {where("platform LIKE ? ", "%#{platform}%").where(status: "Published").limit(50).order("created_at DESC").includes(:documents)}
	scope :getArticlesByAuthor, -> (author = nil) {where("created_by_id = ? ", author).where(status: "Published").limit(50).order("created_at DESC").includes(:documents)}
end