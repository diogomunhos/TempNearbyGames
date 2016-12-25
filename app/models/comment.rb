class Comment < ActiveRecord::Base
	belongs_to :comments, foreign_key: :comment_id, dependent: :destroy
	belongs_to :user, foreign_key: :user_id
	belongs_to :article, foreign_key: :article_id

end