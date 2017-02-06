class GamesController < ApplicationController

	def show
		@game = Game.find_by_friendly_url(params[:game])
		@article = Article.
		@images = ArticleDocument.
	end

	def news
		@game = Game.find_by_friendly_url(params[:game])
	end
end