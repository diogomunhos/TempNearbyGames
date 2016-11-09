class ProfilesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize, :profile_authorize, :has_to_change_password
	
	def my_profile
		user = User.find(session[:user_id])
		@profileName = Profile.find(user.profile_id).name
		@userPreferences = UserPreference.find_by_user_id(session[:user_id])
		if @userPreferences.nil?
			@userPreferences = UserPreference.create(user_id: session[:user_id])
		end	
	end

	def user_profile
		if session[:user_id] === params[:userid]
			redirect_to "/private/profiles/my-profile"
		end
		@user = User.find(params[:userid])
		@profileName = Profile.find(@user.profile_id).name
		@userPreferences = UserPreference.find_by_user_id(params[:userid])
		if @userPreferences.nil?
			@userPreferences = UserPreference.create(user_id: params[:userid])
		end
		@user_profile_image_url = "/assets/images/wahiga/logo-default-profile.jpg"
	    if(@user.documents.length > 0)
	        @user.user_documents.each do |doc|
		        if(doc.document_type === "profile_image")
		            @user_profile_image_url = "/images/#{doc.document_id}"
		            break
		        end 
	        end
	    end
		
	end

	def refresh_profiles
		profiles = Profile.all
		objects = Array.new {Hash.new}
		profiles.each do |profile|
			system_objects.each do |ob|
				hasObject = false
				profile.object_permissions.each do |objProfile|  
					if ob === objProfile.object_name 
						hasObject = true
						break
					end
				end
				if !hasObject
					object = Hash.new
					object[:object_name] = ob
					object[:read_record] = false
					object[:delete_record] = false
					object[:create_record] = false
					object[:edit_record] = false
					object[:read_all_record] = false
					object[:approve_record] = false
					object[:profile_id] = profile.id
					object[:last_updated_by] = session[:user_id]
					objects.push(object)
				end
			end
		end
		
		if objects.size > 0
			permissions = ObjectPermission.create(objects)

			fields = Array.new {Hash.new}
			permissions.each do |p|
				system_fields(p.object_name).each do |sf|
					field = Hash.new
					field[:field_name] = sf
					field[:read_record] = false
					field[:edit_record] = false
					field[:object_permission_id] = p.id
					fields.push(field)
				end
			end

			FieldPermission.create(fields)
		end

		redirect_to "/private/index"
		
	end

	def my_profile_edit
		@user = User.find(session[:user_id])
		@userPreference = UserPreference.find_by_user_id(session[:user_id])
	end

	def upload_profile_image_service
		request = params['file']
		hashDocument = Hash.new
		hashDocument[:file] = request
		print "DEBUG #{hashDocument['file']}"
		document = Document.new(hashDocument)
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		if(document.save)
			userDocuments = UserDocument.where("user_id = ?", session[:user_id])
			unless userDocuments.nil?
				userDocuments.each do |u|
					Document.destroy(u.document_id)
				end
			end

			UserDocument.create(user_id: session[:user_id], document_id: document.id, document_type: "profile_image")			
		else
			hashResult[:isSuccessful] = false
			if document.errors.full_messages.any?
				document.errors.full_messages.each do |error|
					hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
				end
			end
		end

		@result.push(hashResult)
		respond_to do |format|
		    format.json { render json: @result }
		end
	end

	def save_service
		user = User.find(session[:user_id])
		user.name = my_profile_save_params['first_name']
		user.last_name = my_profile_save_params['last_name']
		user.nickname = my_profile_save_params['nickname']
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:errorMessage] = ""
		if(!user.save)
			hashResult[:isSuccessful] = false
			if user.errors.full_messages.any?
				user.errors.full_messages.each do |error|
					hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
				end
			end
		else
			userPreference = UserPreference.find_by_user_id(session[:user_id])
			userPreference.facebook = my_profile_save_params['facebook']
			userPreference.twitter = my_profile_save_params['twitter']
			userPreference.instagram = my_profile_save_params['instagram']
			userPreference.about = my_profile_save_params['about']
			if(!userPreference.save)
				hashResult[:isSuccessful] = false
				if userPreference.errors.full_messages.any?
					userPreference.errors.full_messages.each do |error|
						hashResult[:errorMessage] = if hashResult[:errorMessage] != "" then hashResult[:errorMessage] + " - " + error else error end 
					end
				end
			end
		end

		@result.push(hashResult)
		respond_to do |format|
		    format.json { render json: @result }
		end
		

	end

	def all_profiles
		
	end

	def destroy
		profile = Profile.find(params[:profileid])
		if(profile.destroy)
			redirect_to '/private/profiles'
		end
	end

	def activate
		profile = Profile.find(params[:profileid])
		if(profile.update(id: profile.id, active: true))
			redirect_to "/private/profiles/show/#{profile.id}"
		end
	end

	def deactivate
		profile = Profile.find(params[:profileid])
		if(profile.update(id: profile.id, active: false))
			redirect_to "/private/profiles/show/#{profile.id}"
		end
	end

	def all_profiles_service
		offset_page = (params[:numberPerPage].to_i * params[:pageNumber].to_i) - params[:numberPerPage].to_i 
		@profiles = Profile.getProfilePaged(params[:numberPerPage], offset_page)

		respond_to do |format|
		    format.json { render json: @profiles }
		end
	end

	def count_all_profiles_service
		@profiles = Profile.all.count

		respond_to do |format|
		    format.json { render json: @profiles }
		end
	end

	def new
		@profile = Profile.new
	end

	def show
		@profile = Profile.find(params[:profileid])
		@showActivate = if @profile.active then false else true end
		@showDeactivate = if @profile.active then true else false end
		@showDelete = if @profile.active then false else true end
		@usernamecreate = ""
		@usernameupdate = ""
		user = User.find(@profile.created_by)
		@usernamecreate = user.name
		if(user.last_name != nil)
			@usernamecreate += " " + user.last_name
		end
		if(@profile.created_by != @profile.last_updated_by)
			user = User.find(@profile.last_updated_by)
			@usernameupdate = user.name
			if(user.last_name != nil)
				@usernameupdate += " " + user.last_name
			end
		else
			@usernameupdate = @usernamecreate
		end
		objPermissions = ObjectPermission.where(profile_id: @profile.id).order("object_name")
		@objects = Array.new
		objPermissions.each do |ob|
			op = Hash.new
			op[:name] = "<td><a class=\"btn-link\" href=\"/private/profiles/#{ob.profile_id}/object/#{ob.id}\"> #{ob.object_name}</a></td>"
			op[:permissions] = ""
			op[:permissions] = if ob.read_record then if op[:permissions] != "" then op[:permissions] + ", Read" else "Read" end else op[:permissions] end
			op[:permissions] = if ob.delete_record then if op[:permissions] != "" then op[:permissions] + ", Delete" else "Delete" end else op[:permissions] end
			op[:permissions] = if ob.edit_record then if op[:permissions] != "" then op[:permissions] + ", Edit" else "Edit" end else op[:permissions] end
			op[:permissions] = if ob.read_all_record then if op[:permissions] != "" then op[:permissions] + ", Read all" else "Read all" end else op[:permissions] end
			op[:permissions] = if ob.create_record then if op[:permissions] != "" then op[:permissions] + ", Create" else "Create" end else op[:permissions] end
			op[:permissions] = if ob.approve_record then if op[:permissions] != "" then op[:permissions] + ", Approve" else "Approve" end else op[:permissions] end
			if op[:permissions] === ""
				op[:permissions] = "None"
			end
			op[:last_updated_date] = ob.updated_at
			@objects.push(op)
		end
		print "DEBUG #{@objects}"
	end

	def create
		@profile = Profile.new(profile_params)
		@profile.created_by = session[:user_id]
		@profile.last_updated_by = session[:user_id]
		if(@profile.save)
			objects = Array.new {Hash.new}
			system_objects.each do |ob|
				object = Hash.new
				object[:object_name] = ob
				object[:read_record] = false
				object[:delete_record] = false
				object[:create_record] = false
				object[:edit_record] = false
				object[:read_all_record] = false
				object[:approve_record] = false
				object[:profile_id] = @profile.id
				object[:last_updated_by] = session[:user_id]
				objects.push(object)
			end
			permissions = ObjectPermission.create(objects)

			fields = Array.new {Hash.new}
			permissions.each do |p|
				print "DEBUG OBJECT NAME #{p.object_name}"
				system_fields(p.object_name).each do |sf|
					print "DEBUG SF #{sf}"
					field = Hash.new
					field[:field_name] = sf
					field[:read_record] = false
					field[:edit_record] = false
					field[:object_permission_id] = p.id
					fields.push(field)
				end
			end

			FieldPermission.create(fields)

			redirect_to "/private/profiles/show/#{@profile.id}"
		else
			if @profile.errors.full_messages.any?
				@profile.errors.full_messages.each do |error|
					flash.now[:danger] = if flash[:danger] != nil then flash.now[:danger] + "<br/>" + error else error end 
				end
			end
			respond_to do |format|
				format.html { render :template => "/profiles_secured/new" }
			end
		end
	end

	private
	def profile_params
		params.require(:profile).permit(:name, :active)
	end

	private
	def my_profile_save_params
		params.require(:profile).permit(:first_name, :last_name, :nickname, :about, :facebook, :twitter, :instagram)
	end

end