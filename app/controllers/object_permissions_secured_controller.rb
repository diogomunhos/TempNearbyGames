class ObjectPermissionsSecuredController < ApplicationController
	before_filter :authorize, :profile_authorize
	layout "admapplication"
	def show
		@object = ObjectPermission.find(params[:objectid])
		profile = Profile.find(params[:profileid])
		@profileName = profile.name
		@fields = FieldPermission.where("object_permission_id=?", @object.id).order("field_name")
		@showEdit = true
	end

	def edit
		@object = ObjectPermission.find(params[:objectid])
		profile = Profile.find(params[:profileid])
		@profileName = profile.name
		@fields = FieldPermission.where("object_permission_id=?", @object.id).order("field_name")
		session[:object_id] = params[:objectid]
		session[:profile_id] = params[:profileid]
	end

	def update
		objectid = session[:object_id]
		profileid = session[:profile_id]
		object = ObjectPermission.find(session[:object_id])
		fields = FieldPermission.where("object_permission_id=?", object.id)
		print "DEBUG #{params['fields']}"
		if object.update_attributes(update_object_params)
			if params[:fields] != nil
				fields.each do |fd|
					if(params[:fields][fd.field_name] != nil)
						read = if params[:fields][fd.field_name]['read_record'] != nil then params[:fields][fd.field_name]['read_record'] else false end
						edit = if params[:fields][fd.field_name]['edit_record'] != nil then params[:fields][fd.field_name]['edit_record'] else false end 
						fd.update(id: fd.id, read_record: read, edit_record: edit)
					end
				end
			end
			session[:object_id] = nil
			session[:profile_id] = nil
			redirect_to	"/private/profiles/#{profileid}/object/#{objectid}"
		else
			redirect_to	"/private/profiles/#{profileid}/object/#{objectid}"
		end
	end

	private
	def update_object_params
		params.require(:object).permit(:read_record, :read_all_record, :create_record, :edit_record, :delete_record, :approve_record)
	end

end