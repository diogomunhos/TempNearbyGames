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

  def system_fields
    # return "[{\"Object\": \"Advertising\", \"Fields\": [{}]}]"
  end

  def error_messages(messages)


  end

  def authorize
    redirect_to '/signin' unless current_user
  end

end
