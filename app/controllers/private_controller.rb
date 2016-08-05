class PrivateController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize

	def index 
		@currentUser = User.find(session[:user_id])
		print "DEBUG PRIVATE #{@currentUser}"
		@profile_image_url = "../assets/images/wahiga/logo-default-profile.jpg"
		if(@currentUser.documents.length > 0)
			@currentUser.user_documents.each do |doc|
				if(doc.document_type === "profile_image")
					@profile_image_url = "../images/show_image/#{@currentUser[0].documents[0].id}"
					break
				end
			end
		else
			social = session[:social]
			if(social != nil)
				@profile_image_url = social['image_url']
			end
		end
	end

	def unauthorized_401
		
	end
end