class GamesController < ApplicationController

	def show
		@game = Game.find_by_friendly_url(params[:game])
	end

	def news
		@game = Game.find_by_friendly_url(params[:game])
	end
end