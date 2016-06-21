class HomeController < ApplicationController
	def home
	end

	def default
		redirect_to root_path
	end

end