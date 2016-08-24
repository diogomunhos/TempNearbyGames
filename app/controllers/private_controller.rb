class PrivateController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize, :has_to_change_password

	def index 
		
	end

	def get_permissions_service
		user = User.find(session[:user_id])

		@objectPermissions = ObjectPermission.where("profile_id = ?", user.profile_id)

		respond_to do |format|
		    format.json { render json: @objectPermissions }
		end

	end

	def unauthorized_401
		
	end
end