class ArticlesController < ApplicationController	

	def show
		@article = Article.find_by_friendly_url_and_status(params[:friendly_url], "Published")
		if @article === nil
			redirect_to '/404'
		else
			@popular = Article.get10MostPopularArticles(@article.id)
			@randomArticles = Article.get3RandomArticles(@article.id)
			unless @article.views.nil?
				views = @article.views + 1
				@article.update(views: views)
			else
				@article.update(views: 1)
			end
			@advertising1 = Advertising.getDefaultAdvertising;
		end
	end

	def platform
		@advertising1 = Advertising.getDefaultAdvertising;
		@platform = params[:platform]
		@popular = Article.get10MostPopularArticles(nil)
		platformsAvailable = ["PC", "PS4", "Xbox-one", "Wii-U", "PS3", "3DS", "Mobile", "Vita", "Xbox-360"]
		unless params[:platform].nil?
			ok = false 
			platformsAvailable.each do |p|

				if params[:platform].to_s === p
					ok = true
					break
				end
			end
			if !ok
				redirect_to "/404"
			end
		end

		@articles = Article.getArticleByPlatform(@platform)
	end

end