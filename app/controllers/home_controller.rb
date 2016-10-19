class HomeController < ApplicationController

	def home
		@slider = Article.getLast4ArticlesSlider		
		@articles = Article.getLast10Articles(@slider)
		@advertising1 = Advertising.getDefaultAdvertising;
		if @advertising1 === nil
			@advertising1 = Advertising.getDefaultAdvertising
		end
		@advertising2 = Advertising.getAdvertisingByPosition(1);
		if @advertising2 === nil
			@advertising2 = Advertising.getDefaultAdvertising
		end
		@popular = Article.get10MostPopularArticles(nil)

		set_meta_tags title: "Walkthrough, Hints, News & Reviews for Gamers",
					site: 'Wahiga',
					description: "Wahiga é o seu portal de notícias para games, filmes, seriados e nerd cult. Fique antenado com as novidades para  PS4, Xbox One, PS3, Xbox 360, Wii U, PS Vita, Wii, PC. Dicas, Reviews, trailers, detonados, e muito mais.",
					reverse: true,
					keywords: %w[Gamers Game Walkthrough Hints News Reviews Wahiga games],
					image_src: "https://www.wahiga.com/assets/images/wahiga_logo_2.png",
					application_name: "Wahiga",
					author: "Wahiga"
		set_meta_tags og: {
		  title:    'Walkthrough, Hints, News & Reviews for Gamers',
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
	end

	def default
		redirect_to root_path
	end

	def show_image	
		document = Document.find(params[:id])
		 send_data document.file_contents, :type => document.content_type, :filename => document.file_name, :disposition => 'inline'
	end

	def sitemap
	    # path = Rails.root.join("public", "sitemaps", "sitemap.xml")
	    # print "DEBUG #{path}"
	    # if File.exists?(path)
	    #   render xml: open(path).read
	    # else
	    #   render text: "Sitemap not found.", status: :not_found
	    # end
	end

	def robots
	end

end