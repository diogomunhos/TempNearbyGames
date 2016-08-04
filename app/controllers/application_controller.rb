class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :system_objects, :system_fields, :error_messages


  def current_user
    @currentUser ||= User.find(session[:user_id]) if session[:user_id]
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

end
