class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		social = nil
		if session[:social] != nil
			userTemp = session[:user]
			print "USER #{userTemp['name']}"
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

		if @user.save
			UserPreference.create("user_id": @user.id, "email_content": user_preference_params[:email_content], "accepted_terms_date": Date.today)
			print "SOCIAL #{social['uid']}" 
			if social != nil
				 SocialIdentity.where("uid=? AND provider=?", social['uid'], social['provider']).limit(1).update(social['id'], user_id: @user.id)
			end

			if !@user.email_confirmed
				UserMailer.registration_confirmation(@user).deliver
			end

			session[:user] = nil;

			redirect_to root_path
			# UserPreference.create("user_id": @user.id, "email_content": user_preference_params[:email_content], "accepted_terms_date": Date.today);
		else
			if @user.errors.full_messages.any?
				@user.errors.full_messages.each do |error|
					flash[:success] = if flash[:success] != nil then flash[:success] + "<br/>" + error else error end 
				end
				if @user.errors[:password_confirmation].length > 0
					flash[:danger] = if flash[:danger] != nil then flash[:danger] + "<br/>" + "Passwords must match" else "Passwords must match" end
				end
				if @user.errors[:email].length > 0
					flash[:danger] = if flash[:danger] != nil then flash[:danger] + "<br/>" + @user.errors[:email][0] else @user.errors[:email][0] end
				end
				if @user.errors[:nickname].length > 0
					flash[:danger] = if flash[:danger] != nil then flash[:danger] + "<br/>" + @user.errors[:nickname][0] else @user.errors[:nickname][0] end
				end
			end	
			redirect_to "/signup"
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