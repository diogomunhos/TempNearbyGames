class Article < ActiveRecord::Base
	has_many :article_documents, foreign_key: :article_id, dependent: :destroy
	has_many :documents, through: :article_documents
	has_many :comments, foreign_key: :article_id, dependent: :destroy
	belongs_to :game
	belongs_to :cinema
	# after_save    :expire_contact_all_cache
	# after_destroy :expire_contact_all_cache
	#relation with user on created_by_id

	validates :friendly_url, :uniqueness => {:case_sensitive => false, :message => "Friendly URL is already registered by another article, please choose another"},
							 :format => { without: /\s/, :message => "Friendly URL dont permit white spaces" }

	scope :getLast10Articles, -> (slider = nil) { where.not(id: slider).where(status: "Published").order("created_at desc").limit(10).includes(:documents) }	
	scope :getLast5Articles, -> (slider = nil) { where.not(id: slider).where(status: "Published").order("created_at desc").limit(5).includes(:documents) }	
	scope :getLast5ArticlesByGame, -> (game_id = nil) { where("status = ? AND game_id = ?", "Published", game_id).order("created_at desc").limit(5)}
	scope :getLast4ArticlesSlider, -> { where(is_highlight: true).where(status: "Published").order("created_at desc").limit(4).includes(:documents) }
	scope :getArticleWithDocumentsById, -> (article_id = nil) { where(id: article_id).limit(1).includes(:documents) }
	scope :getArticlePaged, -> (numberPerPage = nil, offset_page = nil) { where("status = ?", "Published").offset(offset_page).limit(numberPerPage).order("created_at DESC") }
	scope :getArticlePublishedPaged, -> (numberPerPage = nil, offset_page = nil) { where("status = ? ", "Published").offset(offset_page).limit(numberPerPage).order("created_at DESC").includes(:documents) }
	scope :getAllArticlesSearchByField, -> (fieldToSearch = nil, searchValue = nil, numberPerPage = nil, offset_page = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").offset(offset_page).limit(numberPerPage).order("updated_at DESC") }
	scope :getAllArticlesSearchByFieldCount, -> (fieldToSearch = nil, searchValue = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").count }
	scope :get10MostPopularArticles, -> (id = nil) { where.not(id: id).where("status = ? AND created_at > ? ", "Published", 30.days.ago).limit(10).order("views DESC").includes(:documents)}
	scope :get3RandomArticles, -> (id = nil) {where.not(id: id).where(status: "Published").order("RANDOM()").limit(3).includes(:documents)}
	scope :get3RandomArticlesFromAuthor, -> (id = nil, author_id = nil) {where.not(id: id).where(status: "Published", created_by_id: author_id).order("RANDOM()").limit(3).includes(:documents)}
	scope :getArticleByPlatform, -> (platform = nil) {where("platform LIKE ? ", "%#{platform}%").where(status: "Published").limit(10).order("created_at DESC").includes(:documents)}
	scope :getArticleByPlatformPaged, -> (platform = nil, numberPerPage = nil, offset_page = nil) {where("platform LIKE ? AND status = ? ", "%#{platform}%", "Published").offset(offset_page).limit(numberPerPage).order("created_at DESC").includes(:documents)}
	scope :getArticlesByAuthor, -> (author = nil) {where("created_by_id = ? ", author).where(status: "Published").limit(10).order("created_at DESC").includes(:documents)}
	scope :getAllArticlesPublished, -> {where("status = ?", "Published").limit(10).order("created_at DESC")}
	scope :getArticlesPublishedByGame, -> (game_id = nil) {where("game_id = ? ", game_id).order("created_at DESC").includes(:documents)}


	def expire_contact_all_cache
	  Rails.cache.clear
	end

	def self.getLast10Articles_cached(article)
	  Rails.cache.fetch("getLast10Articles_#{article}") { getLast10Articles(article) }
	end

	def self.getLast5Articles_cached(article)
	  Rails.cache.fetch("getLast5Articles_#{article}") { getLast5Articles(article) }
	end

	def self.getLast4ArticlesSlider_cached
	  Rails.cache.fetch("getLast4ArticlesSlider") { getLast4ArticlesSlider }
	end

	def self.getArticleWithDocumentsById_cached(id)
	  Rails.cache.fetch("getArticleWithDocumentsById_#{id}") { getArticleWithDocumentsById(id) }
	end

	def self.getArticlePaged_cached(numberPerPage, offset_page)
	  Rails.cache.fetch("getArticlePaged_#{numberPerPage}_#{offset_page}") { getArticlePaged(numberPerPage, offset_page) }
	end

	def self.getArticlePublishedPaged_cached(numberPerPage, offset_page)
	  Rails.cache.fetch("getArticlePublishedPaged_#{numberPerPage}_#{offset_page}") { getArticlePublishedPaged(numberPerPage, offset_page) }
	end

	def self.getAllArticlesSearchByField_cached(fieldToSearch, searchValue, numberPerPage, offset_page)
	  Rails.cache.fetch("getAllArticlesSearchByField_#{fieldToSearch}_#{searchValue}_#{numberPerPage}_#{offset_page}") { getAllArticlesSearchByField(fieldToSearch, searchValue, numberPerPage, offset_page) }
	end

	def self.getArticleByPlatform_cached(platform)
	  Rails.cache.fetch("getArticleByPlatform_#{platform}") { getArticleByPlatform(platform) }
	end

	def self.getArticlesByAuthor_cached(author)
	  Rails.cache.fetch("getArticlesByAuthor_#{author}") { getArticlesByAuthor(author) }
	end

	def self.get10MostPopularArticles_cached(article)
	  Rails.cache.fetch("get10MostPopularArticles_#{article}") { get10MostPopularArticles(article) }
	end

	def self.find_by_friendly_url_and_status_cached(friendly_url, status)
	  Rails.cache.fetch("find_by_friendly_url_and_status_#{friendly_url}_#{status}") { find_by_friendly_url_and_status(friendly_url, status) }
	end

	def self.getAllArticlesPublished_cached
	  Rails.cache.fetch("getAllArticlesPublished") { print "DEBUG ENTROU", getAllArticlesPublished }
	end


end