class SocialMediasSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize, :has_to_change_password
	before_action only: [:all_social_medias, :all_social_medias_service, :count_all_social_medias_service] do 
		check_access("SocialMedia", "read_all_record")
	end
	before_action only: :show do 
		check_access("SocialMedia", "read_record")
	end
	before_action only: [:new, :create] do 
		check_access("SocialMedia", "create_record")
	end
	before_action only: [:edit, :update] do 
		check_access("SocialMedia", "edit_record")
	end
	before_action only: [:destroy] do 
		check_access("SocialMedia", "delete_record")
	end

	def all_social_medias_service
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i 
		socialMedias = SocialMedia.getSocialMediaPaged(params[:numberPerPage], offset_page)

		@socialMedias = Array.new {Hash.new}
		socialMedias.each do |c|
			socialMediaHash = Hash.new
			socialMediaHash[:id] = c.id
			socialMediaHash[:name] = c.name
			socialMediaHash[:created_at] = c.created_at
			@socialMedias.push(socialMediaHash)
		end

		print @socialMedias

		respond_to do |format|
		    format.json { render json: @socialMedias }
		end
	end

	def count_all_social_medias_service
		@socialMedia = SocialMedia.all.count

		respond_to do |format|
		    format.json { render json: @socialMedia }
		end
	end

	def all_social_medias
		
	end

	def new
		@socialMedia = SocialMedia.new
	end

	def show
		@socialMedia = SocialMedia.find(params[:socialMediaid])		
		@showDelete = if !check_access_helper("SocialMedia", "delete_record").nil? then true else false end
	end

	def edit
		@socialMedia = SocialMedia.find(params[:socialMediaid])
		session[:socialMediaid] = params[:socialMediaid]
	end

	def update
		@socialMedia = SocialMedia.find(session[:socialMediaid])
		session[:socialMediaid] = nil
		@socialMedia.name = update_social_media_params["name"]

		if @socialMedia.update(id: @socialMedia.id)
			redirect_to "/private/social-medias/#{@socialMedia.id}/show"
		end
	end

	def create
		@socialMedia = SocialMedia.new(create_social_media_params)

		
		if @socialMedia.save
			redirect_to "/private/social-medias"
		else
			if @socialMedia.errors.full_messages.any?
				@socialMedia.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/social_medias_secured/new" }
			end 
		end		
	end

	def destroy
		SocialMedia.find(params[:socialMediaid]).destroy
		redirect_to "/private/social-medias"
	end

	private 
	def update_social_media_params
		params.require(:social_media).permit(:name, :media_api)
	end

	private 
	def create_social_media_params
		params.require(:social_media).permit(:name, :media_api)
	end
end