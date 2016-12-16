class SessionsController < ApplicationController

	def new

	end

	def create
		user = User.find_by_email_cached(session_params[:email])
		
	    if user && user.authenticate(session_params[:password])
	    	print "DEBUG #{user.id}"
		    session[:user_id] = user.id
		    redirect_to root_path
		else
		  	flash[:danger] = "Your username or password was incorrect"
		    # If user's login doesn't work, send them back to the login form.
		    redirect_to '/signin'
		end
	end

	def create_service
		user = User.find_by_email_cached(session_params[:email])
		
		@result = Hash.new
		@result[:errorMessage] = ""
		@result[:showLink] = false
	    if user && user.authenticate(session_params[:password])
	    	if user.email_confirmed
	    		session[:user_id] = user.id
		    	@result[:login] = true
	    	else
		    	@result[:login] = false
		    	@result[:errorMessage] = "E-mail não confirmado, click no link para enviar o "
		    	@result[:showLink] = true
		    end
		else
		    @result[:login] = false
		    @result[:errorMessage] = "Usuário ou Senha incorreto"
		end

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def create_session_social
		user = User.find_by_email_cached(session_params[:email])
   		social = session[:social]
   		session[:user] = nil;
   		if social === nil
   			redirect_to '/signin'
   		end

	    if user && user.authenticate(session_params[:password])
	    	if user.email_confirmed
				if(social['user_id'] === nil)
					 SocialIdentity.updateUserId_cached(user.id, social['uid'], social['provider'], social['id'])
				end
				session[:user_id] = user.id
				redirect_to root_path
			else
				flash[:danger] = "Your account was not verified yet" #TODO implement error messages
				redirect_to "/social-login/#{social['provider']}"
			end	
		else
			flash[:danger] = "Your username or password was incorrect"
			redirect_to "/social-login/#{social['provider']}"
		end
	end

	def create_session_social_service
		user = User.find_by_email_cached(session_params[:email])
   		social = session[:social]
   		session[:user] = nil
   		@result = Hash.new
   		@result[:login] = true
   		@result[:errorMessage] = ""
   		print "DEBUG #{social}"
   		if social === nil
   			@result[:login] = false
   			@result[:errorMessage] = "Não foi possivel identificar um login por rede social"
   		end

	    if user && user.authenticate(session_params[:password]) && social != nil
	    	print "DEBUG User: #{user}"
	    	if user.email_confirmed
	    		session[:user_id] = user.id
				if(social['user_id'] === nil)
					socialidenty = SocialIdentity.where("uid = ? AND provider = ?", social['uid'], social['provider']).limit(1)
					print "DEBUG social #{socialidenty}"
					socialidenty.update(user_id: user.id)
					 # SocialIdentity.updateUserId(user.id, social['uid'], social['provider'], social['id'])
				end
			else
				@result[:errorMessage] = "Sua conta ainda não foi verificada, por favor verifique a conta atravéz do email enviado" #TODO implement error messages
				@result[:login] = false
			end	
		elsif @result["login"] === true
			@result[:errorMessage] = "Email ou Senha incorreta"
			@result[:login] = false
		end

		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def create_social
		social = SocialIdentity.find_for_oauth(env["omniauth.auth"])
		if social.image_url != env["omniauth.auth"].info.image && env["omniauth.auth"].info.image != nil && env["omniauth.auth"].info.image != ""
			social.update(id: social.id, image_url: env["omniauth.auth"].info.image) 
		end
		session[:social] = social
		user = User.new
		user.name = env["omniauth.auth"].info.name
		user.nickname = env["omniauth.auth"].info.nickname
		user.email = env["omniauth.auth"].info.email
		#TODO Implement method that download image from url and save into a database user_documents as document_type = profile_image
		session[:user] = user;
		print "DEBUG #{social.user_id}"
		if social.user_id?
			user = User.find(social.user_id)
			print "DEBUG #{user.email_confirmed}"
			if user.email_confirmed
				session[:user_id] = user.id
	   			redirect_to root_path
	   		else
	   			flash[:danger] = "Your account was not verified yet" #TODO implement error messages
	   			redirect_to '/signin'
	   		end
		else
			redirect_to "/social-login/#{social.provider}"
		end
	end

	def destroy
		reset_session
		redirect_to '/signin'
	end

	private
	def session_params
		params.permit(:email, :password)
	end

end