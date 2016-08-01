class ObjectPermissionsSecuredController < ApplicationController
	before_filter :authorize
	layout "admapplication"
	def show

	end

end