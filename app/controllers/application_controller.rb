class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :system_objects, :system_fields, :error_messages, :check_profile, :check_user_access_read_all_helper, :check_access_to_publish_helper


  def current_user
    @currentUser ||= User.find(session[:user_id]) if session[:user_id]
    unless @currentUser.nil? 
      @profile_image_url = "/assets/images/wahiga/logo-default-profile.jpg"
      if(@currentUser.documents.length > 0)
        @currentUser.user_documents.each do |doc|
          if(doc.document_type === "profile_image")
            @profile_image_url = "/images/show_image/#{@currentUser[0].documents[0].id}"
            break
          end
        end
         return @currentUser
      else
        social = session[:social]
        if(social != nil)
          @profile_image_url = social['image_url']
        end
        return @currentUser
      end
    else
      return @currentUser

    end
  end

  def check_profile
    @profile = Profile.find(@currentUser.profile_id)
    unless @profile.nil?
      if @profile.name === "Guest"
        return nil
      else
        return @profile
      end
    else
      return nil
    end
  end

  def system_objects
    return objects = ["Advertising", "Article", "Document", "ArticleDocument", "Profile", "User", "UserDocument", "UserPreference"]
  end

  def system_fields(object)
    case object 
    when "Advertising"  
      return ["is_active", "advertising_type", "position", "html_body", "tags", "quantity", "pages", "is_default", "created_at", "updated_at"] 
    when "Article"  
      return ["title", "body", "subtitle", "preview", "created_at", "updated_at", "article_type", "is_highlight", "tags", "friendly_url", "created_by_id", "last_updated_by_id", "created_by_name", "last_updated_by_name", "status"]
    when "Document"
      return ["file_name", "content_type", "file_contents", "created_at", "updated_at", "tags", "file_size"] 
    when "ArticleDocument"
      return ["document_type", "created_at", "updated_at", "article_id", "document_id"]
    when "Profile"
      return ["name", "created_at", "updated_at", "active", "created_by", "last_updated_by"]
    when "User"
      return ["name", "last_name", "email", "nickname", "profile_id", "role_id", "password", "created_at", "updated_at", "password_confirmation", "birthdate", "email_confirmed", "confirm_token"] 
    when "UserDocument"
      return ["user_id", "document_id", "document_type", "created_at", "updated_at"]
    when "UserPreference"
      return ["email_content", "accepted_terms_date", "user_id", "created_at", "updated_at"]
    else
      return []
    end
  end

  def error_messages(messages)


  end

  def authorize
    redirect_to '/signin' unless current_user
  end

  def profile_authorize
    redirect_to '/404' unless check_profile
  end

  def check_access_helper(object, permission)
    if @profile.object_permissions.any?
      @profile.object_permissions.each do |ob|
        if(ob.object_name.to_s === object)
          if ob[permission]
            unless params[:userid].nil? && permission != "read_record" && object != "User"
              if params[:userid].to_i === session[:user_id].to_i || ((params[:userid].to_i != session[:user_id].to_i) && ob["read_all_record"] )
                return true
              else
                return nil
              end
            else
              return true
            end
          else
            return nil
          end
        end
      end
    else
      return nil
    end
  end
  def check_access_to_publish_helper(profileName)
    if @profile.name === profileName
      return true
    else
      return nil
    end
  end

  def check_user_access_read_all
    redirect_to '/signup' unless check_user_access_read_all_helper
  end

  def check_access(object, permission)
    redirect_to '/private/unauthorized' unless check_access_helper(object, permission)
  end

  def check_access_to_publish(profileName)
    redirect_to '/private/unauthorized' unless check_access_to_publish_helper(profileName)
  end

end
