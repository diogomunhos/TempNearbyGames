class ArticlesController < ApplicationController	

	def show
		@article = Article.find_by_friendly_url(params[:friendly_url])
		@advertising1 = Advertising.getDefaultAdvertising;
	end

	def platform
		@advertising1 = Advertising.getDefaultAdvertising;
		@platform = params[:platform]
		platformsAvailable = ["PC", "Ps4", "Xbox-one", "Wii-U", "Ps3", "3DS", "Mobile", "Vita", "Xbox-360"]
		if params[:platform].nil?
			ok = false 
			platformsAvailable.each do |p|
				if params[:platform] === p
					ok = true
					break
				end
			end
			if ok === false
				redirect_to "/404"
			end
		end

		@articles = Article.all.order("created_at").includes(:documents)
	end

end