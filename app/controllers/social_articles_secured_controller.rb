class SocialArticlesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize, :has_to_change_password
	# before_action only: [:all_social_medias, :all_social_medias_service, :count_all_social_medias_service] do 
	# 	check_access("SocialMedia", "read_all_record")
	# end
	# before_action only: :show do 
	# 	check_access("SocialMedia", "read_record")
	# end
	before_action only: [:new, :create_social_article_service] do 
	 	check_access("SocialMedia", "create_record")
	end
	# before_action only: [:edit, :update] do 
	# 	check_access("SocialMedia", "edit_record")
	# end
	# before_action only: [:destroy] do 
	# 	check_access("SocialMedia", "delete_record")
	# end

	def new
		@articleId = params[:articleId]
		@socialMedias = SocialMedia.all
	end

	def create_social_article_service
		@socialArticle = SocialArticle.new(create_social_article_params)
		if @socialArticle.save
			articleDocument = ArticleDocument.where("article_id = ? AND document_type = ?", @socialArticle.article_id, "Header").limit(1)
			if articleDocument != nil
				documentId = articleDocument[0].document_id
			else
				articleDocument = ArticleDocument.where("article_id = ? AND document_type = ?", @socialArticle.article_id, "Body").limit(1)
				documentId = articleDocument[0].document_id
			end

			@socialArticle.update(document_id: documentId)
		end
		respond_to do |format|
		    format.json { render json: @socialArticle }
		end
	end

	private 
	def create_social_article_params
		params.require(:social_article).permit(:title, :subtitle, :article_id, :post_title, :social_media_id, :status, :published_id, :published_time)
	end
end	