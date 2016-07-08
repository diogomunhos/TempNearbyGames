class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :file_name
      t.string :content_type
      t.binary :file_contents

      t.timestamps null: false
    end
  end
end
