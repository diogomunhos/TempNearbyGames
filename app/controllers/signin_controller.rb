class SigninController < ApplicationController

	def signin
		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
			redirect_to '/home'
		end
		@showLogin = true
	end

end