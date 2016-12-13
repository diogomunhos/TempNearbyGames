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

	 def flash_message_home_page
	 	messages = ""
	    [:success, :info, :warning, :error].each {|type|
	      if flash[type]
	      	messages += "<span class=\"the-#{type}-msg\"><i class=\"fa fa-warning\"></i>#{flash[type]}</span>"
	      end
	    }

	    messages
	 end
	 


	 def social_login_url(provider)
	 	redirect to "/social-login/#{provider}"
	 end


end
