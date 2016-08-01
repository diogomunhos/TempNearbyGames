class ArticlesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize
	before_action :init_article_type, only: [:new, :create, :edit]

	def my_articles
		
	end

	def all_articles
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i 
		@articles = Article.getArticlePaged(params[:numberPerPage], offset_page)

		respond_to do |format|
		    format.json { render json: @articles }
		end
	end

	def count_articles
		@articles = Article.all.count
		respond_to do |format|
		    format.json { render json: @articles }
		end
	end

	def count_search_articles
		@articles = Article.getAllArticlesSearchByField(params[:fieldToSearch], params[:searchValue]).size
		respond_to do |format|
		    format.json { render json: @articles }
		end
	end

	def search_all_articles
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i
		@articles = Article.getAllArticlesSearchByField(params[:fieldToSearch], params[:searchValue], params[:numberPerPage], offset_page)
		respond_to do |format|
		    format.json { render json: @articles }
		end
	end

	def edit
		article = Article.getArticleWithDocumentsById(params[:articleid])
		@article = article[0]
		article[0].article_documents.each do |doc|
			if(doc.document_type === "header")
				@document1 = doc.document	
			elsif (doc.document_type === "thumb")
				@document2 = doc.document	
			else
				@document3 = doc.document	
			end
		end
	end

	def update
		@article = Article.find(article_params[:id])
		if params[:document] != nil
			if document_params.has_key?(:file1)
				document = ArticleDocument.where("article_id=? and document_type=?",@article.id, "header")
				document.destroy(document[0].id) if document.length > 0
				@document1 = Document.new(document_params, "file1")
				if @document1.save
					ArticleDocument.create(article_id: @article.id, document_id: @document1.id, document_type: "header");
				end
			end
			if document_params.has_key?(:file2)
				document = ArticleDocument.where("article_id=? and document_type=?",@article.id, "thumb")

				document.destroy(document[0].id) if document.length > 0
				@document2 = Document.new(document_params, "file2")
				if @document2.save
					ArticleDocument.create(article_id: @article.id, document_id: @document2.id, document_type: "thumb");
				end
			end
			if document_params.has_key?(:file3)
				document = ArticleDocument.where("article_id=? and document_type=?",@article.id, "article")
				document.destroy(document[0].id) if document.length > 0
				@document3 = Document.new(document_params, "file3")
				if @document3.save
					ArticleDocument.create(article_id: @article.id, document_id: @document3.id, document_type: "article");
				end
			end
		end
		user = User.find(session[:user_id])
		username = user.name
		if (user.last_name != nil)
			username += " " + user.last_name
		end
		@article.update(id: @article.id, last_updated_by_name: username, last_updated_by_id: user.id)

		historic = Historic.new
		historic.entity = "article"
		changesString = "["
		if @article.title != article_params[:title]
			changesString += "{\"field\": \"Title\", \"before\": \"#{@article.title}\", \"after\": \"#{article_params['title']}\"}"
		end
		if @article.subtitle != article_params[:subtitle]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Subtitle\", \"before\": \"#{@article.subtitle}\", \"after\": \"#{article_params['subtitle']}\"}"
		end
		if @article.article_type != article_params[:article_type]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Type\", \"before\": \"#{@article.article_type}\", \"after\": \"#{article_params['article_type']}\"}"
		end
		if @article.friendly_url != article_params[:friendly_url]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Friendly URL\", \"before\": \"#{@article.friendly_url}\", \"after\": \"#{article_params['friendly_url']}\"}"
		end
		if @article.is_highlight != article_params[:is_highlight]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Is Highlighted\", \"before\": \"#{@article.is_highlight}\", \"after\": \"#{article_params['is_highlight']}\"}"
		end
		if @article.preview != article_params[:preview]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Preview\", \"before\": \"#{@article.preview}\", \"after\": \"#{article_params['preview']}\"}"
		end
		if @article.body != article_params[:body]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Body\", \"before\": \"#{@article.body}\", \"after\": \"#{article_params['body']}\"}"
		end
		if @article.tags != article_params[:tags]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Tags\", \"before\": \"#{@article.tags}\", \"after\": \"#{article_params['tags']}\"}"
		end

		changesString += "]"
		historic.changed_fields = changesString
		historic.user_id = session[:user_id]
		historic.object_id = @article.id

		if @article.update_attributes(article_params)
			historic.save
			redirect_to "/private/articles/show/#{@article.id}"
		else
			if @article.errors.full_messages.any?
				@article.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/articles_secured/edit" }
			end
		end
	end


	def new
		@article = Article.new 
	end

	def show
		article = Article.where(id: params[:articleid]).includes(:documents)
		@article = if article.any? then article[0] else Article.new end	
		@tags = if @article.tags != "" && @article.tags != nil then @article.tags.split(',') else Array.new end
		@showEdit = if @article.status === "Draft" || @article.status === "Reject" then true else false end
		@showDelete = if @showEdit then true else false end
		@showSendApproval = if @article.status === "Draft" then true else false end
		@showReject = if @article.status === "Waiting for approval" then true else false end
		@showApprove = if @article.status === "Waiting for approval" then true else false end
		@showPublish = if @article.status === "Approved" then true else false end
		@showSchedule = if @article.status === "Approved" then true else false end
		historic = Historic.where("entity=? AND object_id=?", "article", @article.id)
		@historic = Array.new
		historic.each do |h|
			user = User.find(h.user_id)
			change_array = JSON.parse(h.changed_fields)
			change_array.each do |c|
				historic_hash = Hash.new
				historic_hash[:field] = c['field']
				historic_hash[:before] = c['before']
				historic_hash[:after] = c['after']
				historic_hash[:updated_date] = h.created_at
				historic_hash[:username] = user.name
				@historic.push(historic_hash)
			end
		end

		print "DEBUG #{@historic}"
	end

	def create
		@article = Article.new(article_params)
		@article.status = "Draft"
		user = User.find(session[:user_id])
		@article.created_by_id = user.id
		username = user.name
		if (user.last_name != nil)
			username += " " + user.last_name
		end
		@article.created_by_name = username
		@article.last_updated_by_name = username
		@article.last_updated_by_id = user.id
		@document1 = Document.new(document_params, "file1")
		@document2 = Document.new(document_params, "file2")
		@document3 = Document.new(document_params, "file3")


		if @article.save && @document1.save && @document2.save && @document3.save
			ArticleDocument.create(article_id: @article.id, document_id: @document1.id, document_type: "header");
			ArticleDocument.create(article_id: @article.id, document_id: @document2.id, document_type: "thumb");
			ArticleDocument.create(article_id: @article.id, document_id: @document3.id, document_type: "article");
			redirect_to "/private/articles/my-articles"
		else
			if @article.errors.full_messages.any?
				@article.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/articles_secured/new" }
			end 
		end
	end

	def destroy
		Article.find(params[:articleid]).destroy
		redirect_to "/private/articles/my-articles"
	end

	def document_params
		params.require(:document).permit(:file1, :file2, :file3)
	end

	private
	def article_params
		params.require(:article).permit(:id, :title, :subtitle, :article_type, :friendly_url, :is_highlight, :preview, :body, :tags)
	end

	private
	def init_article_type
		@article_type = ["Article"]
	end

	

end