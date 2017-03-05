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
		@article = Article.find(params[:articleId])
		if @article.status == "Published"
			if request.host.include? "localhost"
				@articleurl = "https://localhost:3000"
			else
				@articleurl = "https://www.wahiga.com"
			end
			if @article.game_id != nil
				@articleurl += "/#{@article.game.friendly_url}/news/#{@article.friendly_url}"
			elsif @article.cinema_id != nil
				@articleurl += "/#{@article.cinema.friendly_url}/news/#{@article.friendly_url}"
			else
				@articleurl += "/news/#{@article.friendly_url}"
			end

			articleDocument = ArticleDocument.where("article_id = ? AND document_type = ?", @article.id, "Header").limit(1)
			if request.host.include? "localhost"
				@documenturl = "https://localhost:3000"
			else
				@documenturl = "https://www.wahiga.com"
			end
			if articleDocument != nil
				@documenturl += "/images/#{articleDocument[0].document_id}/#{articleDocument[0].document.file_name}"
			else
				articleDocument = ArticleDocument.where("article_id = ? AND document_type = ?", @socialArticle.article_id, "Body").limit(1)
				@documenturl += "/images/#{articleDocument[0].document_id}/#{articleDocument[0].document.file_name}"
			end
			socialArticles = SocialArticle.where("article_id = ? ", params[:articleId])

			socialMediasPosted = Array.new
			socialArticles.each do |sa|
				socialMediasPosted.push(sa.social_media_id)
			end
			if socialMediasPosted.size() > 0
				@socialMedias = SocialMedia.where("id NOT IN (?)", socialMediasPosted)
			else
				@socialMedias = SocialMedia.all
			end
		else
			redirect_to "/private/articles/show/#{@article.id}"
		end
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