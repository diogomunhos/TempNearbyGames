class SocialLoginController < ApplicationController
	def social
		@showLogin = true
		if params[:provider] === "twitter"
			@user = User.new
			@user.nickname = session[:user]['nickname']
		elsif params[:provider] === "facebook"
			@user = User.new
		elsif params[:provider] === "Google"
			@user = User.new
		else

		end

	end
end