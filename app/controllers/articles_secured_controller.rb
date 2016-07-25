class ArticlesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize

	def my_articles

	end


	def new

	end

end