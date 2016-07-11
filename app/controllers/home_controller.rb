class HomeController < ApplicationController

	def home
		@slider = Article.getLast3ArticlesSlider		
		@highlight = Article.getLast4HighlightedArticles(@slider)
		@articles = Article.getLast10Articles(@slider, @highlight)
		@advertising1 = Advertising.getDefaultAdvertising;
		if @advertising1 === nil
			@advertising1 = Advertising.getDefaultAdvertising
		end
		@advertising2 = Advertising.getAdvertisingByPosition(1);
		if @advertising2 === nil
			@advertising2 = Advertising.getDefaultAdvertising
		end
	end

	def default
		redirect_to root_path
	end

	def show_image	
		document = Document.find(params[:id])
		 send_data document.file_contents, :type => document.content_type, :filename => document.file_name, :disposition => 'inline'
	end

end