class CinemasSecuredController < ApplicationController
	layout "admapplication"
	
	before_filter :authorize, :profile_authorize, :has_to_change_password
	before_action only: [:my_cinemas, :all_cinemas, :count_cinemas, :count_search_cinemas, :search_all_cinemas] do 
		check_access("Cinema", "read_all_record")
	end
	before_action only: :show do 
		check_access("Cinema", "read_record")
	end
	before_action only: [:new, :create, :create_cinema_service, :update_cinema_service] do 
		check_access("Cinema", "create_record")
	end
	before_action only: [:edit, :update, :update_cinema_service] do 
		check_access("Cinema", "edit_record")
	end

	before_action only: [:destroy] do 
		check_access("Cinema", "delete_record")
	end

	before_action only: [:publish] do 
		check_access_to_publish("Administrator")
	end

	def my_cinemas
		
	end

	def create_cinema_companies_service
		@cinemaCompaniesService = Cinema.new(cinema_companies_params)

		@cinemaCompaniesToCreate = []	

		@cinemaCompaniesService.cinema_companies.each do |cinemaCompany|
			if cinemaCompany.id != nil && cinemaCompany.id != ""
				CinemaCompany.update(cinemaCompany.id, :cinema_id => cinemaCompany.cinema_id, :company_id => cinemaCompany.company_id, :company_type => cinemaCompany.company_type)
			else
				@cinemaCompaniesToCreate.push(cinemaCompany)
			end
		end

		@cinemaCompaniesToCreate.each(&:save)

		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def destroy_cinema_company_service
		CinemaCompany.find(params[:id]).destroy

		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def upload_cinema_image_service
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
			cinema = Cinema.find(params['cinema_id'])
			if cinema != nil && cinema.document_id != nil
				Document.destroy(cinema.document_id)
			end

			Cinema.update(params['cinema_id'], :document_id => document.id)
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

	def create_cinema_service
		print "DEBUG #{cinema_params_create_by_service}"
		@cinema = Cinema.new(cinema_params_create_by_service)
	
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		hashResult[:cinemaid] = ""
		if !@cinema.save
			hashResult[:isSuccessful] = false
			if @cinema.errors.full_messages.any?
				@cinema.errors.full_messages.each do |error|
					hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
				end
			end
		else
			hashResult[:cinemaid] = @cinema.id
		end
		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def update_cinema_service
		
		@cinema = Cinema.find(cinema_params_update_by_service[:id])
		
		require 'json'

		historic = Historic.new
		historic.entity = "cinema"
		changesString = "["

		if @cinema.name != cinema_params[:name]
			changesString += "{\"field\": \"Name\", \"before\": \"#{@cinema.name}\", \"after\": \"#{cinema_params['name']}\"}"
		end
		if @cinema.release_date != cinema_params[:release_date]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Release Date\", \"before\": \"#{@cinema.release_date}\", \"after\": \"#{cinema_params['release_date']}\"}"
		end
		if @cinema.cinema_type != cinema_params[:cinema_type]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Type\", \"before\": \"#{@cinema.cinema_type}\", \"after\": \"#{cinema_params['cinema_type']}\"}"
		end
		if @cinema.wahiga_rating != cinema_params[:wahiga_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Wahiga Rating\", \"before\": \"#{@cinema.wahiga_rating}\", \"after\": \"#{cinema_params['wahiga_rating']}\"}"
		end
		if @cinema.user_rating != cinema_params[:user_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"User Rating\", \"before\": \"#{@cinema.user_rating}\", \"after\": \"#{cinema_params['user_rating']}\"}"
		end
		if @cinema.description != cinema_params[:description]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Description\", \"before\": \"#{@cinema.description}\", \"after\": \"#{cinema_params['description']}\"}"
		end
		if @cinema.genre != cinema_params[:genre]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Genre\", \"before\": \"#{@cinema.genre}\", \"after\": \"#{cinema_params['genre']}\"}"
		end

		changesString += "]"
		historic.changed_fields = changesString
		historic.user_id = session[:user_id]
		historic.object_id = @cinema.id
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		if @cinema.update_attributes(cinema_params_update_by_service)
			historic.save
		else
			hashResult[:isSuccessful] = false
			if @cinema.errors.full_messages.any?
				@cinema.errors.full_messages.each do |error|
					hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
				end
			end
		end

		@result.push(hashResult)

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def all_cinemas
		numberPerPage = params[:numberPerPage].presence.to_i || 10
		pageNumber = params[:pageNumber].presence.to_i || 1

		offset_page = (numberPerPage * pageNumber) - numberPerPage 
		@cinemas = Cinema.getCinemaPaged(numberPerPage, offset_page)

		respond_to do |format|
		    format.json { render json: @cinemas }
		end
	end

	def count_cinemas
		@cinemas = Cinema.all.count
		respond_to do |format|
		    format.json { render json: @cinemas }
		end
	end

	def count_search_cinemas
		@cinemas = Cinema.getAllCinemasSearchByField(params[:fieldToSearch], params[:searchValue]).size
		respond_to do |format|
		    format.json { render json: @cinemas }
		end
	end

	def search_all_cinemas
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i
		@cinemas = Cinema.getAllCinemasSearchByField(params[:fieldToSearch], params[:searchValue], params[:numberPerPage], offset_page)
		respond_to do |format|
		    format.json { render json: @cinemas }
		end
	end

	def edit
		require 'json'
		@cinema = Cinema.find(params[:cinemaid])

		cinemaCompanies = CinemaCompany.where(cinema_id: params[:cinemaid])

		@cinemaCompanies = if cinemaCompanies.any? then cinemaCompanies.to_json end

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end	

		@cinema_image_url = ""
	    if(@cinema.document_id)
			@cinema_image_url = "/images/#{@cinema.document_id}"
	    end	

	end

	def update
		require 'json'
		@cinema = Cinema.find(cinema_params[:id])

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end

		historic = Historic.new
		historic.entity = "cinema"
		changesString = "["
		if @cinema.name != cinema_params[:name]
			changesString += "{\"field\": \"Name\", \"before\": \"#{@cinema.name}\", \"after\": \"#{cinema_params['name']}\"}"
		end
		if @cinema.release_date != cinema_params[:release_date]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Release Date\", \"before\": \"#{@cinema.release_date}\", \"after\": \"#{cinema_params['release_date']}\"}"
		end
		if @cinema.platform != cinema_params[:platform]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Platform\", \"before\": \"#{@cinema.platform}\", \"after\": \"#{cinema_params['platform']}\"}"
		end
		if @cinema.wahiga_rating != cinema_params[:wahiga_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Wahiga Rating\", \"before\": \"#{@cinema.wahiga_rating}\", \"after\": \"#{cinema_params['wahiga_rating']}\"}"
		end
		if @cinema.user_rating != cinema_params[:user_rating]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"User Rating\", \"before\": \"#{@cinema.user_rating}\", \"after\": \"#{cinema_params['user_rating']}\"}"
		end
		if @cinema.description != cinema_params[:description]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Description\", \"before\": \"#{@cinema.description}\", \"after\": \"#{cinema_params['description']}\"}"
		end
		if @cinema.genre != cinema_params[:genre]
			changesString += if changesString != "[" then ", " else "" end
			changesString += "{\"field\": \"Genre\", \"before\": \"#{@cinema.genre}\", \"after\": \"#{cinema_params['genre']}\"}"
		end

		changesString += "]"
		historic.changed_fields = changesString
		historic.user_id = session[:user_id]
		historic.object_id = @cinema.id

		if @cinema.update_attributes(cinema_params)
			historic.save
			redirect_to "/private/cinemas/show/#{@cinema.id}"
		else
			if @cinema.errors.full_messages.any?
				@cinema.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/cinemas_secured/edit" }
			end
		end
	end

	def new
		@cinema = Cinema.new 

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end
	end

	def show
		require 'json'
		user = User.find(session[:user_id])
		profile = Profile.find(user.profile_id)
		cinema = Cinema.where(id: params[:cinemaid]).includes(:companies)

		@cinema = if cinema.any? then cinema[0] else Cinema.new end	

		cinemaCompanies = CinemaCompany.where(cinema_id: params[:cinemaid])

		@cinemaCompanies = if cinemaCompanies.any? then cinemaCompanies.to_json end

		companies = Company.all;

		@companies = if companies.any? then companies.to_json end

		@cinema_image_url = ""
	    if(@cinema.document_id)
			@cinema_image_url = "/images/#{@cinema.document_id}"
	    end
		
		@showEdit = if !check_access_helper("Cinema", "edit_record").nil? then true else false end
		@showDelete = if !check_access_helper("Cinema", "delete_record").nil? then true else false end

		historic = Historic.where("entity=? AND object_id=?", "cinema", @cinema.id)
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
		@cinema = Cinema.new(cinema_params)

		#TODO Save image / companies
		if @cinema.save
			redirect_to "/private/cinemas"
		else
			if @cinema.errors.full_messages.any?
				@cinema.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/cinemas_secured/new" }
			end 
		end
	end

	def destroy
		Cinema.find(params[:cinemaid]).destroy
		redirect_to "/private/cinemas"
	end

	private
	def cinema_params
		params.require(:cinema).permit(:id, :name, :release_date, :cinema_type, :wahiga_rating, :user_rating, :description, :genre, :friendly_url, :trailer)
	end

	private
	def cinema_params_create_by_service
		params.require(:cinema).permit(:name, :release_date, :cinema_type, :wahiga_rating, :user_rating, :description, :genre, :friendly_url, :trailer)
	end

	private
	def cinema_params_update_by_service
		params.require(:cinema).permit(:id, :release_date, :cinema_type, :wahiga_rating, :user_rating, :description, :genre, :friendly_url, :trailer)
	end

	private
	def cinema_companies_params
		params.require(:cinema).permit(:id, :name, cinema_companies_attributes: [:id, :cinema_id, :company_id, :company_type])
	end		
end