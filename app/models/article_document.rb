class ArticleDocument < ActiveRecord::Base
	belongs_to :article, foreign_key: :article_id
	belongs_to :document, foreign_key: :document_id
end