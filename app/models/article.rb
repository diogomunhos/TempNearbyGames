class Article < ActiveRecord::Base
	has_many :article_documents, foreign_key: :article_id, dependent: :destroy
	has_many :documents, through: :article_documents

	scope :getLast10Articles, -> (slider = nil, highlight = nil) { where.not(id: slider).where.not(id: highlight).order('created_at desc').limit(10).includes(:documents) }	
	scope :getLast3ArticlesSlider, -> { where(is_highlight: true).order('created_at desc').limit(3).includes(:documents) }
	scope :getLast4HighlightedArticles, -> (slider = nil) { where(is_highlight: true).where.not(id: slider).order('created_at desc').limit(4).includes(:documents)}

end