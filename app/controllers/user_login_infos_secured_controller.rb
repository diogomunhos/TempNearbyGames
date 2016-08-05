class UserLoginInfosSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize, :has_to_change_password

	def create 
		@user = User.find(params[:userid])
		profile = Profile.find(@user.profile_id) if @user.profile_id != nil
		@profilename = if @user.profile_id != nil then profile.name else "" end
		if @user.user_login_info != nil
			userinfo = @user.user_login_info
			userinfo.send_password_reset
		else
			userinfo = UserLoginInfo.create(is_locked: false, user_id: @user.id)
			userinfo.send_password_reset
		end

		flash.now[:success] = "Email reset sented"
		respond_to do |format|
			format.html { render :template => "/users_secured/show" }
		end

	end

	def reset_password

	end

end