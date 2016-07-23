class PrivateController < ApplicationController
	layout "admapplication"
	before_filter :authorize

	def index 
		
	end
end