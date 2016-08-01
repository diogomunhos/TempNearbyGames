class ProfilesSecuredController < ApplicationController
	layout "admapplication"
	before_filter :authorize
	
	def my_profile

	end

	def new
		@profile = Profile.new
	end

	def show
		@profile = Profile.find(params[:profileid])
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
			if(ObjectPermission.create(objects))
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