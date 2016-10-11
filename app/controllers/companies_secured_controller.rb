class CompaniesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize, :has_to_change_password
	before_action only: [:all_companies, :all_companies_service, :count_all_companies_service] do 
		check_access("Company", "read_all_record")
	end
	before_action only: :show do 
		check_access("Company", "read_record")
	end
	before_action only: [:new, :create] do 
		check_access("Company", "create_record")
	end
	before_action only: [:edit, :update] do 
		check_access("Company", "edit_record")
	end
	before_action only: [:destroy] do 
		check_access("Company", "delete_record")
	end

	def all_companies_service
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i 
		companies = Company.getCompanyPaged(params[:numberPerPage], offset_page)

		@companies = Array.new {Hash.new}
		companies.each do |c|
			companyHash = Hash.new
			companyHash[:id] = c.id
			companyHash[:name] = c.name
			companyHash[:created_at] = c.created_at
			@companies.push(companyHash)
		end

		print @companies

		respond_to do |format|
		    format.json { render json: @companies }
		end
	end

	def count_all_companies_service
		@companies = Company.all.count

		respond_to do |format|
		    format.json { render json: @companies }
		end
	end

	def all_companies
		
	end

	def new
		@company = Company.new
	end

	def show
		@company = Company.find(params[:companyid])		
		@showDelete = if !check_access_helper("Company", "delete_record").nil? then true else false end
	end

	def edit
		@company = Company.find(params[:companyid])
		session[:companyid] = params[:companyid]
	end

	def update
		@company = Company.find(session[:companyid])
		session[:companyid] = nil
		@company.name = update_company_params["name"]

		if @company.update(id: @company.id)
			redirect_to "/private/companies/#{@company.id}/show"
		end
	end

	def create
		@company = Company.new(create_company_params)

		
		if @company.save
			redirect_to "/private/companies"
		else
			if @company.errors.full_messages.any?
				@company.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/companies_secured/new" }
			end 
		end		
	end

	def destroy
		Company.find(params[:companyid]).destroy
		redirect_to "/private/companies"
	end

	private 
	def update_company_params
		params.require(:company).permit(:name)
	end

	private 
	def create_company_params
		params.require(:company).permit(:name)
	end
end