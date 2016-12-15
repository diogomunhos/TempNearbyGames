class UsersController < ApplicationController
	def new
		@user = User.new
	end

	

	def create_user_service
		print "DEBUG #{user_params}"
		@result = Hash.new
		@result[:signup] = true
		@result[:errorMessage] = ""
		@user = User.new(user_params)
		social = nil
		if session[:social] != nil
			userTemp = session[:user]
			@user.name = userTemp['name']
			@user.last_name = userTemp['last_name']
			social = session[:social]
			@user.email_confirmed = if social['provider'] != "twitter" then 
										if userTemp['email'] === @user.email then 
											true 
										else 
											false
										end
									else 
										false 
									end
		end
		profile = Profile.find_by_name('Guest')
		@user.profile_id = profile.id
		if @user.save
			UserPreference.create(user_id: @user.id, email_content: false, accepted_terms_date: Date.today)
			if social != nil
				 SocialIdentity.where("uid=? AND provider=?", social['uid'], social['provider']).limit(1).update(social['id'], user_id: @user.id)
			end

			if !@user.email_confirmed
				UserMailer.registration_confirmation(@user).deliver_now
			end
			session[:user] = nil;
		else
			if @user.errors.full_messages.any?
				if @user.errors[:email].length > 0
					@result[:signup] = false
					@result[:errorMessage] = if @result[:errorMessage] != "" then @result[:errorMessage] + ", " + @user.errors[:email][0] else @user.errors[:email][0] end
				end
				if @user.errors[:nickname].length > 0
					@result[:signup] = false
					@result[:errorMessage] = if @result[:errorMessage] != "" then @result[:errorMessage] + ", " + @user.errors[:nickname][0] else @user.errors[:nickname][0] end
				end
			end	
		end

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def resend_confirmation_email
		@result = Hash.new
		user = User.find_by_email(params[:email])
		UserMailer.registration_confirmation(user).deliver_now
		@result[:success] = true

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def email_confirmed
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
		else
			@showLogin = true			
		end
	end

	def confirm_email
	    user = User.find_by_confirm_token(params[:id])
	    if user
	      user.email_activate
	      flash[:success] = "Bem vindo ao Wahiga! Seu email foi confirmado, por favor faça o login para continuar."
	      redirect_to '/email-confirmed'
	    else
	      flash[:error] = "Desculpe, este email de confirmação expirou ou já foi utilizado, por favor envie o email de confirmação novamente"
	      redirect_to '/email-confirmed'
	    end
	end

	def profile
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		@profile = Hash.new
		@showEdit = false
		if @user != nil
			@showLogin = false
		else
			@showLogin = true
			if @user.id === session[:user_id]
				@showEdit = true
			end
		end
		userProfile = User.find(params[:userid])
		@profile[:fullname] = if userProfile.last_name != nil then userProfile.name + " " + userProfile.last_name else userProfile.name end
		@profile[:showEdit] = @showEdit
		@profile[:nickname] = userProfile.nickname
		@profile[:birthdate] = userProfile.birthdate
		@profile[:signupDate] = userProfile.created_at
		@profile[:about] = ""
		@profile[:socialMedia] = Array.new
		socialIndenties = SocialIdentity.where("user_id = ? ", params[:userid])
		if socialIndenties != nil
			socialIndenties.each do |social|
				socialhash = Hash.new
				socialhash[:uid] = social.uid
				socialhash[:provider] = social.provider
				@profile[:socialMedia].push(socialhash)
			end
		end	

	end

	private 
		def user_params
	      params.require(:user).permit(:name, :last_name, :nickname, :email, :password, :password_confirmation, :birthdate)
	    end

	private
		def user_preference_params
			params.require(:user_preference).permit(:terms_of_use, :email_content)
		end	
end