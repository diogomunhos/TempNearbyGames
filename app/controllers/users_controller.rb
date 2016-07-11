class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:notice] = "You signed up sucessfully"
			flash[:color] = "valid"
		else
			flash[:notice] = "Form is invalid"
			flash[:color] = "invalid"
		end
		redirect_to "/signup"
	end

	def user_params
      params.require(:user).permit(:name, :last_name, :nickname, :email, :password, :password_confirmation)
    end

end