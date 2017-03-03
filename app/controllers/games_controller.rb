class GamesController < ApplicationController

	def show
		load_game_information("show")
	end

	def news
		load_game_information("news")

		@articles = Article.getArticlesPublishedByGame(@game.id)
	end

	def load_game_information(type)
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
		else
			@showLogin = true			
		end
		@game = Game.find_by_friendly_url(params[:game])
		if @game != nil
			gameUrl = ""
			if @game.document_id != nil
				@gamePicture = Document.find(@game.document_id)
				gameUrl = "https://www.wahiga.com/image/#{@gamePicture.file_name}"
			end
			@publishers = GameCompany.getPublishersFromGame(@game.id)
			@developers = GameCompany.getDevelopersFromGame(@game.id)

			finalUrl = "https://www.wahiga.com/"
			if type == "news"
				finalUrl = "https://www.wahiga.com/#{@game.friendly_url}/news"
			else
				finalUrl = "https://www.wahiga.com/#{@game.friendly_url}/news"
			end
			set_meta_tags title: "#{@game.name.camelize}",
					site: 'Wahiga',
					reverse: true,
					image_src: "#{gameUrl}",
					application_name: "Wahiga"
			set_meta_tags og: {
			  title:    "#{@game.name.camelize}",
			  type:     'website',
			  url:      "#{finalUrl}",
			  image:    "#{gameUrl}",
			  site_name: "Wahiga",
			  locale: 'pt_BR'
			}
			set_meta_tags twitter: {
			  card: "summary",
			  site: "@wahiga_official",
			  creator: "@wahiga_official"
			}
			set_meta_tags fb:{
				profile_id: "http://www.facebook.com/Wahiga_Official"
			}
			set_meta_tags canonical: "#{finalUrl}"
		else
			redirect_to root_path
		end
	end
end