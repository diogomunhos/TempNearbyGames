class UserMailer < ActionMailer::Base
	default :from => "social@wahiga.com"

	def registration_confirmation(user)
		@user = user
		mail(:to => "#{user.name} <#{user.email}>", :subject => "Registration Confirmation")
	end

	def password_reset(user_id)
	  @user = User.find(user_id)
	  @userinfo = @user.user_login_info
	  mail :to => @user.email, :subject => "Password Reset"
	end
end	