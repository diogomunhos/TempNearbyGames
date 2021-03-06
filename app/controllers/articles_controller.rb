class ArticlesController < ApplicationController	

	def show
		@article = Article.find_by_friendly_url_and_status(params[:friendly_url], "Published")
		if @article === nil
			redirect_to '/404'
		else
			@popular = Article.get10MostPopularArticles(@article.id)
			unless @article.views.nil?
				views = @article.views + 1
				@article.update(views: views)
			else
				@article.update(views: 1)
			end
			@advertising1 = Advertising.getDefaultAdvertising;
			@author = Hash.new
			authorProfile = UserPreference.find_by_user_id(@article.created_by_id)
			user = User.find(@article.created_by_id)
			@author[:full_name] = user.name
			@author[:full_name] += " " + user.last_name unless user.last_name.nil?
			@author[:profile_image_url] = "/assets/images/wahiga/logo-default-profile.jpg"
		    if(user.documents.length > 0)
		        user.user_documents.each do |doc|
			        if(doc.document_type === "profile_image")
			            @author[:profile_image_url] = "/images/show_image/#{doc.document_id}"
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
			@author[:total_of_articles] = Article.where("created_by_id = ?", @article.created_by_id).count
			@randomArticles = Article.get3RandomArticlesFromAuthor(@article.id, @article.created_by_id)
			imageUrl = ""
			@article.article_documents.each do |image|
				if image.document_type === "Header"
					imageUrl = "https://www.wahiga.com/images/show_image/#{image.document.id}"
					break
				end
			end
			if imageUrl === ""
				@article.article_documents.each do |image|
					if image.document_type === "Body"
						imageUrl = "https://www.wahiga.com/images/show_image/#{image.document.id}"
						break
					end
				end
			end

			set_meta_tags title: "#{@article.title}",
					site: 'Wahiga',
					description: "#{@article.preview}",
					reverse: true,
					keywords: "#{@article.tags}",
					image_src: "#{imageUrl}",
					application_name: "Wahiga",
					author: "#{@author['full_name']}"
			set_meta_tags og: {
			  title:    "#{@article.title}",
			  type:     'website',
			  description: "#{@article.preview}",
			  url:      "https://www.wahiga.com/News/#{@article.friendly_url}",
			  image:    "#{imageUrl}",
			  site_name: "Wahiga"
			}
			set_meta_tags twitter: {
			  card: "summary",
			  site: "@wahiga_official",
			  creator: "@wahiga_official"
			}
		end
	end

	def platform
		@advertising1 = Advertising.getDefaultAdvertising;
		@platform = params[:platform]
		@popular = Article.get10MostPopularArticles(nil)
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

		@articles = Article.getArticleByPlatform(@platform)
	end

end