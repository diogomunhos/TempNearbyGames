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
		@populares = Article.get10MostPopularArticles(nil)
	end

	def default
		redirect_to root_path
	end

	def show_image	
		document = Document.find(params[:id])
		 send_data document.file_contents, :type => document.content_type, :filename => document.file_name, :disposition => 'inline'
	end

end