class ProfilesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize
	
	def show

	end

end