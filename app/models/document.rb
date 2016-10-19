class Document < ActiveRecord::Base
	has_many :article_documents, foreign_key: :document_id, dependent: :destroy
	has_many :articles, through: :article_documents
	has_many :user_documents, foreign_key: :document_id, dependent: :destroy
	has_many :users, through: :user_documents

	def initialize(params = {})
		file = params.delete(:file)
		super
		if file
			filename  = file.original_filename
			filename = filename.gsub(" ", "-")
			filename = filename.gsub("_", "-")
			self.file_name = sanitize_filename(filename)
			self.content_type = file.content_type
			self.file_contents = file.read
		end
	end

	private
	def sanitize_filename(filename)
		return File.basename(filename)
	end
end
