class CreateArticleDocuments < ActiveRecord::Migration
	def change
		create_table :article_documents do |t|
			t.string :document_type
			t.integer :article_id
			t.integer :document_id

			t.timestamps null: false
		end
	end
end
