class UsersSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize
	before_action only: [:all_users, :all_users_service, :count_all_users_service] do 
		check_access("User", "read_all_record")
	end
	before_action only: :show do 
		check_access("User", "read_record")
	end
	before_action only: [:new, :create] do 
		check_access("User", "create_record")
	end
	before_action only: [:edit, :update] do 
		check_access("User", "edit_record")
	end

	def all_users_service
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i 
		users = User.getUserPaged(params[:numberPerPage], offset_page)
		profileIds = Array.new
		users.each do |u|
			profileIds.push(u.profile_id) if u.profile_id != nil
		end
		if profileIds.any?
			profiles = Profile.where("id IN ( ? )", profileIds)
			profileHash = Hash.new
			profiles.each do |p|
				profileHash["#{p.id}"] = p.name
			end
		end

		@users = Array.new {Hash.new}
		users.each do |u|
			userHash = Hash.new
			username = u.name
			username += if u.last_name != nil then " " + u.last_name else "" end
			userHash[:id] = u.id
			userHash[:name] = username
			userHash[:email] = u.email
			userHash[:nickname] = u.nickname
			userHash[:profile] = if u.profile_id != nil then profileHash["#{u.profile_id}"] else "" end
			userHash[:profile_id] = if u.profile_id != nil then u.profile_id else "" end
			userHash[:email_confirmed] = u.email_confirmed
			userHash[:created_at] = u.created_at
			@users.push(userHash)	
		end


		respond_to do |format|
		    format.json { render json: @users }
		end
	end

	def count_all_users_service
		@users = User.all.count

		respond_to do |format|
		    format.json { render json: @users }
		end
	end

	def all_users
		
	end

	def new
		@user = User.new
		@profilename = ""
	end

	def show
		@user = User.find(params[:userid])		
		profile = Profile.find(@user.profile_id) if @user.profile_id != nil
		@profilename = if @user.profile_id != nil then profile.name else "" end 
	end

	def edit
		@user = User.find(params[:userid])
		session[:userid] = params[:userid]
		@profiles = Profile.where(active: true)
		profile = Profile.find(@user.profile_id) if @user.profile_id != nil
		@profilename = if @user.profile_id != nil then profile.name else "" end 
	end

	def update
		@user = User.find(session[:userid])
		session[:userid] = nil
		@user.name = update_user_params["name"]
		@user.email = update_user_params["email"]
		@user.last_name = update_user_params["last_name"]
		@user.nickname = update_user_params["nickname"]
		print "DEBUG #{update_user_params['profile_name']}"
		profile = Profile.where("name = ?", update_user_params["profile_name"]).limit(1)
		if profile.any?
			@user.profile_id = profile[0].id	
		end

		if @user.update(id: @user.id)
			redirect_to "/private/users/#{@user.id}/show"
		end
	end

	def create
		@user = User.new(create_user_params)
		profile = Profile.where("name=?", create_profile_params["name"])
		@user.password = "wahiga@2016"

		if profile.any?
			@user.profile_id = profile[0].id
			if @user.save
				userinfo = UserLoginInfo.create(is_locked: false, user_id: @user.id, reset_password_token: SecureRandom.urlsafe_base64)

				UserMailer.registration_confirmation_with_password_set(@user, userinfo.reset_password_token).deliver

				redirect_to "/private/users"
			else
				if @user.errors.full_messages.any?
					@user.errors.full_messages.each do |error|
						flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
					end
				end
				respond_to do |format|
					format.html { render :template => "/users_secured/new" }
				end 
			end
		else
			flash.now[:danger] = "Profile not founded, please click on search button than select one profile of the list"
			respond_to do |format|
				format.html { render :template => "/users_secured/new" }
			end
		end

		
	end

	def confirm_email_set_password

	end


	private 
	def update_user_params
		params.require(:user).permit(:name, :email, :last_name, :nickname, :profile_name)
	end

	private 
	def create_user_params
		params.require(:user).permit(:name, :email, :last_name, :nickname)
	end

	private 
	def create_profile_params
		params.require(:profile).permit(:name)
	end
end