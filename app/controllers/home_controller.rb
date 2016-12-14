class HomeController < ApplicationController
	self.page_cache_directory = -> { Rails.root.join("public", request.domain) }
	caches_page :home, :show_image
	def home
		@slider = Article.getLast4ArticlesSlider_cached		
		@articles = Article.getLast5Articles_cached(@slider)
		@popular = Article.get10MostPopularArticles_cached(nil)
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
		else
			@showLogin = true			
		end

		set_meta_tags title: "Notícias, Dicas, Novidades Para Jogadores",
					site: 'Wahiga',
					description: "Wahiga é o seu portal de notícias para games, filmes, seriados e nerd cult. Fique antenado com as novidades para  PS4, Xbox One, PS3, Xbox 360, Wii U, PS Vita, Wii, PC. Dicas, Reviews, trailers, detonados, e muito mais.",
					reverse: true,
					image_src: "https://www.wahiga.com/assets/images/wahiga_logo_2.png",
					application_name: "Wahiga",
					author: "Wahiga"
		set_meta_tags og: {
		  title:    'Notícias, Dicas, Novidades Para Jogadores',
		  type:     'website',
		  description: 'Wahiga é o seu portal de notícias para games, filmes, seriados e nerd cult. Fique antenado com as novidades para  PS4, Xbox One, PS3, Xbox 360, Wii U, PS Vita, Wii, PC. Dicas, Reviews, trailers, detonados, e muito mais.',
		  url:      'https://www.wahiga.com',
		  image:    'https://www.wahiga.com/assets/images/wahiga_logo_2.png',
		  site_name: "Wahiga"
		}
		set_meta_tags twitter: {
		  card: "summary",
		  site: "@wahiga_official",
		  creator: "@wahiga_official"
		}
		set_meta_tags alternate: {
			"pt-br" => "https://www.wahiga.com/"
		}

	end

	def default
		redirect_to root_path
	end

	def show_image	
		document = Document.find(params[:id])
		expires_in 7.days, :public => true
		 send_data document.file_contents, :type => document.content_type, :filename => document.file_name, :disposition => 'inline'
	end

end