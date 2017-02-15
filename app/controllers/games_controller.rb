class GamesController < ApplicationController

	def show
		@game = Game.find_by_friendly_url(params[:game])
	end

	def news
		@game = Game.find_by_friendly_url(params[:game])
		@articles = Article.getArticlesPublishedByGame(@game.id)
		@publishers = GameCompany.getPublishersFromGame(@game.id)
		@developers = GameCompany.getDevelopersFromGame(@game.id)
	end
end