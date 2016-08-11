class ArticlesController < ApplicationController	

	def show
		@article = Article.find_by_friendly_url(params[:friendly_url])
		@advertising1 = Advertising.getDefaultAdvertising;
	end

end