class Document < ActiveRecord::Base
	has_many :article_documents, foreign_key: :document_id, dependent: :destroy
	has_many :articles, through: :article_documents
	has_many :user_documents, foreign_key: :document_id, dependent: :destroy
	has_many :users, through: :user_documents
	attr_accessor :file1
	attr_accessor :file2
	attr_accessor :file3

	def initialize(params = {}, fileName)
		file = params.delete(fileName)
		super
		if file
			self.file_name = sanitize_filename(file.original_filename)
			self.content_type = file.content_type
			self.file_contents = file.read
		end
	end

	private
	def sanitize_filename(filename)
		return File.basename(filename)
	end
end
