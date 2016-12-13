class ArticlesController < ApplicationController	
	self.page_cache_directory = -> { Rails.root.join("public", request.domain) }
	caches_page :show, :all_articles, :platform

	def get_articles_service
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i 
		@articles = Article.getArticlePublishedPaged(params[:numberPerPage], offset_page)

		@result = Array.new
		@articles.each do |a|
			item = Hash.new
			item[:title] = a.title
			item[:preview] = a.preview
			item[:url] = if a.game != nil then "/#{a.game.friendly_url}/#{a.article_type.downcase}/#{a.friendly_url}" else "/#{a.article_type.downcase}/#{a.friendly_url}" end
			item[:image_url] = nil
			a.article_documents.each do |image|
				if image.document_type === "Thumb"
					item[:image_url] = "/images/#{image.document.id}/#{image.document.file_name}"
				end
			end 
			@result.push(item)
		end

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def get_platform_articles_service
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i 
		@articles = Article.getArticleByPlatformPaged(params[:platform], params[:numberPerPage], offset_page)

		@result = Array.new
		@articles.each do |a|
			item = Hash.new
			item[:title] = a.title
			item[:preview] = a.preview
			item[:url] = if a.game != nil then "/#{a.game.friendly_url}/#{a.article_type.downcase}/#{a.friendly_url}" else "/#{a.article_type.downcase}/#{a.friendly_url}" end
			item[:image_url] = nil
			a.article_documents.each do |image|
				if image.document_type === "Thumb"
					item[:image_url] = "/images/#{image.document.id}/#{image.document.file_name}"
				end
			end 
			@result.push(item)
		end

		respond_to do |format|
		    format.json { render json: @result }
		end		
	end

	def show
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
		else
			@showLogin = true			
		end
		@article = Article.find_by_friendly_url_and_status_cached(params[:friendly_url], "Published")
		expires_in 3.minutes, :public => true
		print "DEBUG #{Rails.cache}"
		if @article === nil
			redirect_to '/404'
		else
			@popular = Article.get10MostPopularArticles_cached(@article.id)
			expires_in 3.minutes, :public => true
			@stats = Rails.cache.stats.first.last
			unless @article.views.nil?
				views = @article.views + 1
				@article.update(views: views)
			else
				@article.update(views: 1)
			end
			# @advertising1 = Advertising.getDefaultAdvertising;
			@author = Hash.new
			authorProfile = UserPreference.find_by_user_id_cached(@article.created_by_id)
			expires_in 3.minutes, :public => true
			user = User.find_cached(@article.created_by_id)
			expires_in 3.minutes, :public => true
			@author[:id] = user.id
			@author[:full_name] = user.name
			@author[:full_name] += " " + user.last_name unless user.last_name.nil?
			@author[:profile_image_url] = "/assets/images/wahiga/logo-default-profile.jpg"
		    if(user.documents.length > 0)
		        user.user_documents.each do |doc|
			        if(doc.document_type === "profile_image")
			            @author[:profile_image_url] = "/images/#{doc.document_id}/#{doc.document.file_name}"
			            break
			        end
		        end
		    end
		    @author[:facebook] = "";
		    @author[:twitter] = "";
		    @author[:instagram] = "";
		    @author[:about] = "";
			unless authorProfile.nil?
				@author[:facebook] = authorProfile.facebook;
		    	@author[:twitter] = authorProfile.twitter;
		    	@author[:instagram] = authorProfile.instagram;
		    	@author[:about] = authorProfile.about;
			end
			@author[:total_of_articles] = Article.where("created_by_id = ? AND status = ?", @article.created_by_id, "Published").count
			expires_in 3.minutes, :public => true
			@randomArticles = Article.get3RandomArticlesFromAuthor(@article.id, @article.created_by_id)
			expires_in 3.minutes, :public => true
			imageUrl = ""
			@article.article_documents.each do |image|
				if image.document_type === "Header"
					imageUrl = "https://www.wahiga.com/images/#{image.document.id}/#{image.document.file_name}"
					break
				end
			end
			if imageUrl === ""
				@article.article_documents.each do |image|
					if image.document_type === "Body"
						imageUrl = "https://www.wahiga.com/images/#{image.document.id}/#{image.document.file_name}"
						break
					end
				end
			end

			finalUrl = "https://www.wahiga.com/news/#{@article.friendly_url}"
			if @article.game != nil
				finalUrl = "https://www.wahiga.com/#{@article.game.friendly_url}/news/#{@article.friendly_url}"
			end
			set_meta_tags title: "#{@article.title}",
					site: 'Wahiga',
					description: "#{@article.preview}",
					reverse: true,
					keywords: "#{@article.tags}",
					image_src: "#{imageUrl}",
					application_name: "Wahiga"
			set_meta_tags og: {
			  title:    "#{@article.title}",
			  type:     'website',
			  description: "#{@article.preview}",
			  url:      "#{finalUrl}",
			  image:    "#{imageUrl}",
			  site_name: "Wahiga",
			  locale: 'pt_BR'
			}
			set_meta_tags twitter: {
			  card: "summary",
			  site: "@wahiga_official",
			  creator: "@wahiga_official"
			}
			set_meta_tags article: {
				published_time: @article.created_at,
				publisher: "http://www.facebook.com/Wahiga_Official",
				section: "#{@article.title}",
				tag: "#{@article.tags}",
			}
			set_meta_tags fb:{
				profile_id: "http://www.facebook.com/Wahiga_Official"
			}
			set_meta_tags alternate: {
				"pt" => "#{finalUrl}"
			}
			set_meta_tags canonical: "#{finalUrl}"

			@amplink = "<link rel=\"amphtml\" href=\"#{finalUrl}.amp\">"
		end
	end

	def all_articles
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
		else
			@showLogin = true			
		end
		@popular = Article.get10MostPopularArticles_cached(nil)
		title = "Todos os artigos"
		alternate = "https://www.wahiga.com/all-articles"
		if params["author_id"] != nil
			@articles = Article.getArticlesByAuthor_cached(params["author_id"])
			title = "Todos os artigos | " + params["author_name"].gsub('_', ' ')
			alternate = "https://www.wahiga.com/all-articles/#{params['author_name']}/#{params['author_id']}"
		else
			@articles = Article.getAllArticlesPublished_cached
		end
		@articles = Article.all
		set_meta_tags title: title,
				site: 'Wahiga',
				reverse: true,
				application_name: "Wahiga",
				description: "#{title}"
		set_meta_tags og: {
		  title:    title,
		  type:     'website',
		  site_name: "Wahiga",
		  locale: 'pt_BR',
		  description: "#{title}"
		}
		set_meta_tags twitter: {
		  card: "summary",
		  site: "@wahiga_official",
		  creator: "@wahiga_official"
		}
		set_meta_tags article: {
			publisher: "http://www.facebook.com/Wahiga_Official",
			section: title,
		}
		set_meta_tags fb:{
			profile_id: "http://www.facebook.com/Wahiga_Official"
		}
		set_meta_tags alternate: {
			"pt-br" => "#{alternate}"
		}

	end

	def platform
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
		else
			@showLogin = true			
		end
		@platform = params[:platform]
		@popular = Article.get10MostPopularArticles_cached(nil)
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
		set_meta_tags title: "#{@platform}",
					site: 'Wahiga',
					description: "Todos os artigos referente a plataforma #{@platform}",
					reverse: true,
					keywords: "#{@platform}",
					application_name: "Wahiga"
		set_meta_tags og: {
		  title:    "#{@platform}",
		  type:     'website',
		  description: "Todos os artigos referente a plataforma #{@platform}",
		  url:      "https://www.wahiga.com/platform/#{@platform}",
		  site_name: "Wahiga"
		}
		set_meta_tags twitter: {
		  card: "summary",
		  site: "@wahiga_official",
		  creator: "@wahiga_official"
		}
		set_meta_tags alternate: {
			"pt-br" => "https://www.wahiga.com/platform/#{@platform}"
		}
		@articles = Article.getArticleByPlatform_cached(@platform)
	end

end