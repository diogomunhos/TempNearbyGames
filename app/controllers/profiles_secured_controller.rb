class ProfilesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize
	
	def my_profile

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

end