class CreateUserDocuments < ActiveRecord::Migration
  def change
    create_table :user_documents do |t|
    	t.integer :user_id
    	t.integer :document_id
    	t.string :document_type
    end
  end
end
