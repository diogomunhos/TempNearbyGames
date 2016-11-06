class GamesSecuredController < ApplicationController
	layout "admapplication"
	
	before_filter :authorize, :profile_authorize, :has_to_change_password
	before_action only: [:my_games, :all_games, :count_games, :count_search_games, :search_all_games] do 
		check_access("Game", "read_all_record")
	end
	before_action only: :show do 
		check_access("Game", "read_record")
	end
	before_action only: [:new, :create, :create_game_service, :update_game_service] do 
		check_access("Game", "create_record")
	end
	before_action only: [:edit, :update, :update_game_service] do 
		check_access("Game", "edit_record")
	end

	before_action only: [:destroy] do 
		check_access("Game", "delete_record")
	end

	before_action only: [:publish] do 
		check_access_to_publish("Administrator")
	end

	def my_games
		
	end

	def create_game_companies_service
		@gameCompaniesService = Game.new(game_companies_params)

		@gameCompaniesToCreate = []	

		@gameCompaniesService.game_companies.each do |gameCompany|
			if gameCompany.id != nil && gameCompany.id != ""
				GameCompany.update(gameCompany.id, :game_id => gameCompany.game_id, :company_id => gameCompany.company_id, :company_type => gameCompany.company_type)
			else
				@gameCompaniesToCreate.push(gameCompany)
			end
		end

		@gameCompaniesToCreate.each(&:save)

		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def destroy_game_company_service
		GameCompany.find(params[:id]).destroy

		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def upload_game_image_service
		request = params['file']
		hashDocument = Hash.new
		hashDocument[:file] = request
		print "DEBUG #{hashDocument['file']}"
		document = Document.new(hashDocument)
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		if(document.save)
			game = Game.find(params['game_id'])
			if game != nil && game.document_id != nil
				Document.destroy(game.document_id)
			end

			Game.update(params['game_id'], :document_id => document.id)
		else
			hashResult[:isSuccessful] = false
			if document.errors.full_messages.any?
				document.errors.full_messages.each do |error|
					hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
				end
			end
		end

		@result.push(hashResult)
		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def create_game_service
		@game = Game.new(game_params_create_by_service)
	
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		hashResult[:gameid] = ""
		if !@game.save
			hashResult[:isSuccessful] = false
			if @game.errors.full_messages.any?
				@game.errors.full_messages.each do |error|
					hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
				end
			end
		else
			hashResult[:gameid] = @game.id
		end
		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def update_game_service
		
		@game = Game.find(game_params_update_by_service[:id])
		
		require 'json'

		historic = Historic.new
		historic.entity = "game"
		changesString = "["

		if @game.name != game_params[:name]
			changesString += "{\"field\": \"Name\", \"before\": \"#{@game.name}\", \"after\": \"#{game_params['name']}\"}"
		end
		if @game.release_date != game_params[:release_date]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Release Date\", \"before\": \"#{@game.release_date}\", \"after\": \"#{game_params['release_date']}\"}"
		end
		if @game.platform != game_params[:platform]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Platform\", \"before\": \"#{@game.platform}\", \"after\": \"#{game_params['platform']}\"}"
		end
		if @game.wahiga_rating != game_params[:wahiga_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Wahiga Rating\", \"before\": \"#{@game.wahiga_rating}\", \"after\": \"#{game_params['wahiga_rating']}\"}"
		end
		if @game.user_rating != game_params[:user_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"User Rating\", \"before\": \"#{@game.user_rating}\", \"after\": \"#{game_params['user_rating']}\"}"
		end
		if @game.description != game_params[:description]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Description\", \"before\": \"#{@game.description}\", \"after\": \"#{game_params['description']}\"}"
		end
		if @game.genre != game_params[:genre]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Genre\", \"before\": \"#{@game.genre}\", \"after\": \"#{game_params['genre']}\"}"
		end

		changesString += "]"
		historic.changed_fields = changesString
		historic.user_id = session[:user_id]
		historic.object_id = @game.id
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		if @game.update_attributes(game_params_update_by_service)
			historic.save
		else
			hashResult[:isSuccessful] = false
			if @game.errors.full_messages.any?
				@game.errors.full_messages.each do |error|
					hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
				end
			end
		end

		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def all_games
		numberPerPage = params[:numberPerPage].presence.to_i || 10
		pageNumber = params[:pageNumber].presence.to_i || 1

		offset_page = (numberPerPage * pageNumber) - numberPerPage 
		@games = Game.getGamePaged(numberPerPage, offset_page)

		respond_to do |format|
		    format.json { render json: @games }
		end
	end

	def count_games
		@games = Game.all.count
		respond_to do |format|
		    format.json { render json: @games }
		end
	end

	def count_search_games
		@games = Game.getAllGamesSearchByField(params[:fieldToSearch], params[:searchValue]).size
		respond_to do |format|
		    format.json { render json: @games }
		end
	end

	def search_all_games
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i
		@games = Game.getAllGamesSearchByField(params[:fieldToSearch], params[:searchValue], params[:numberPerPage], offset_page)
		respond_to do |format|
		    format.json { render json: @games }
		end
	end

	def edit
		require 'json'
		@game = Game.find(params[:gameid])

		gameCompanies = GameCompany.where(game_id: params[:gameid])

		@gameCompanies = if gameCompanies.any? then gameCompanies.to_json end

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end	

		@game_image_url = ""
	    if(@game.document_id)
			@game_image_url = "/images/show_image/#{@game.document_id}"
	    end	

		#game = Game.getGameWithCompaniesById(params[:gameid])
		#@game = game[0]
	end

	def update
		require 'json'
		@game = Game.find(game_params[:id])

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end

		historic = Historic.new
		historic.entity = "game"
		changesString = "["
		if @game.name != game_params[:name]
			changesString += "{\"field\": \"Name\", \"before\": \"#{@game.name}\", \"after\": \"#{game_params['name']}\"}"
		end
		if @game.release_date != game_params[:release_date]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Release Date\", \"before\": \"#{@game.release_date}\", \"after\": \"#{game_params['release_date']}\"}"
		end
		if @game.platform != game_params[:platform]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Platform\", \"before\": \"#{@game.platform}\", \"after\": \"#{game_params['platform']}\"}"
		end
		if @game.wahiga_rating != game_params[:wahiga_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Wahiga Rating\", \"before\": \"#{@game.wahiga_rating}\", \"after\": \"#{game_params['wahiga_rating']}\"}"
		end
		if @game.user_rating != game_params[:user_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"User Rating\", \"before\": \"#{@game.user_rating}\", \"after\": \"#{game_params['user_rating']}\"}"
		end
		if @game.description != game_params[:description]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Description\", \"before\": \"#{@game.description}\", \"after\": \"#{game_params['description']}\"}"
		end
		if @game.genre != game_params[:genre]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Genre\", \"before\": \"#{@game.genre}\", \"after\": \"#{game_params['genre']}\"}"
		end

		changesString += "]"
		historic.changed_fields = changesString
		historic.user_id = session[:user_id]
		historic.object_id = @game.id

		if @game.update_attributes(game_params)
			historic.save
			redirect_to "/private/games/show/#{@game.id}"
		else
			if @game.errors.full_messages.any?
				@game.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/games_secured/edit" }
			end
		end
	end

	def new
		@game = Game.new 

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end
	end

	def show
		require 'json'
		user = User.find(session[:user_id])
		profile = Profile.find(user.profile_id)
		game = Game.where(id: params[:gameid]).includes(:companies)

		@game = if game.any? then game[0] else Game.new end	

		gameCompanies = GameCompany.where(game_id: params[:gameid])

		@gameCompanies = if gameCompanies.any? then gameCompanies.to_json end

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end

		@game_image_url = ""
	    if(@game.document_id)
			@game_image_url = "/images/show_image/#{@game.document_id}"
	    end
		
		@showEdit = if !check_access_helper("Game", "edit_record").nil? then true else false end
		@showDelete = if !check_access_helper("Game", "delete_record").nil? then true else false end

		historic = Historic.where("entity=? AND object_id=?", "game", @game.id)
		@historic = Array.new
		# historic.each do |h|
		# 	user = User.find(h.user_id)
		# 	change_array = JSON.parse(h.changed_fields)
		# 	change_array.each do |c|
		# 		historic_hash = Hash.new
		# 		historic_hash[:field] = c['field']
		# 		historic_hash[:before] = c['before']
		# 		historic_hash[:after] = c['after']
		# 		historic_hash[:updated_date] = h.created_at
		# 		historic_hash[:username] = user.name
		# 		@historic.push(historic_hash)
		# 	end
		# end
	end

	def create
		@game = Game.new(game_params)

		#TODO Save image / companies
		if @game.save
			redirect_to "/private/games"
		else
			if @game.errors.full_messages.any?
				@game.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/games_secured/new" }
			end 
		end
	end

	def destroy
		Game.find(params[:gameid]).destroy
		redirect_to "/private/games"
	end

	private
	def game_params
		params.require(:game).permit(:id, :name, :release_date, :platform, :wahiga_rating, :user_rating, :description, :genre, :friendly_url)
	end

	private
	def game_params_create_by_service
		params.require(:game).permit(:name, :release_date, :platform, :wahiga_rating, :user_rating, :description, :genre, :friendly_url)
	end

	private
	def game_params_update_by_service
		params.require(:game).permit(:id, :release_date, :platform, :wahiga_rating, :user_rating, :description, :genre, :friendly_url)
	end

	private
	def game_companies_params
		params.require(:game).permit(:id, :name, game_companies_attributes: [:id, :game_id, :company_id, :company_type])
	end		
end