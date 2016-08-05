class UserInvitationsSecuredController < ApplicationController
	layout "confirm_invitation"
	before_filter :authorize, only: [:update, :change_password]
	before_filter :profile_authorize, only: [:update, :change_password]

	def confirm_invitation
		@user = User.find_by_confirm_token(params[:confirmToken])
		@user.user_login_info.reset_password_token
		unless @user.nil? && @user.user_login_info.nil?
			if(@user.user_login_info.reset_password_token != params[:resetPasswordToken])
				redirect_to '/signup'
			else
				session[:user_id] = @user.id
				unless @user.email_confirmed
					@user.email_confirmed = true
					@user.save	
				end 				
				redirect_to "/private/change-password-invitation"
			end
		else
			redirect_to '/'
		end
	end

	def change_password

	end

	def update
		@user = User.find(session[:user_id])
		if @user.update_attributes(change_password_params)
			userInfo = @user.user_login_info
			userInfo.reset_password_token = nil
			userInfo.reset_request_date = nil
			userInfo.save
			redirect_to '/private/index'
		else
			if @user.errors.full_messages.any?
				if @user.errors[:password_confirmation].length > 0
					flash.now[:danger] = if flash.now[:danger] != nil then flash.now[:danger] + "<br/>" + "Passwords must match" else "Passwords must match" end
				end
				if @user.errors[:email].length > 0
					flash.now[:danger] = if flash.now[:danger] != nil then flash.now[:danger] + "<br/>" + @user.errors[:email][0] else @user.errors[:email][0] end
				end
				if @user.errors[:nickname].length > 0
					flash.now[:danger] = if flash.now[:danger] != nil then flash.now[:danger] + "<br/>" + @user.errors[:nickname][0] else @user.errors[:nickname][0] end
				end
			end

			respond_to do |format|
				format.html { render :template => "/user_invitations_secured/change_password" }
			end
		end
	end

	private
	def change_password_params
		params.require(:user).permit(:password, :password_confirmation)
	end

end 