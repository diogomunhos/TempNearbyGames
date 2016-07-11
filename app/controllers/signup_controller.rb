class SignupController < ApplicationController

	def signup
		@user = User.new
	end

end