module ApplicationHelper

	def flash_message
	    messages = ""
	    [:success, :info, :warning, :danger].each {|type|
	      if flash[type]
	        messages += "<p class=\"alert alert-#{type}\">#{flash[type]}</p>"
	      end
	    }

	    messages
	 end


	 def social_login_url(provider)
	 	redirect to "/social-login/#{provider}"
	 end


end
