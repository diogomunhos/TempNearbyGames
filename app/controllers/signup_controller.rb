class SignupController < ApplicationController

	def signup

		@user = User.find(session[:user_id]) if session[:user_id] != nil
		if @user != nil
			@showLogin = false
			redirect_to '/home'
		else
			@showLogin = true
			@user = User.new
		end
	end

end