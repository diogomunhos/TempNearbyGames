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
				UserMailer.registration_confirmation(@user).deliver
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

	def confirm_email
	    user = User.find_by_confirm_token(params[:id])
	    if user
	      user.email_activate
	      flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
	      Please sign in to continue."
	      redirect_to '/signup'
	    else
	      flash[:danger] = "Sorry. User does not exist"
	      redirect_to '/signup'
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