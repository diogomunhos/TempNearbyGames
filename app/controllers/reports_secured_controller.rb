class ReportsSecuredController < ApplicationController
	layout "admapplication"
	
	before_filter :authorize, :profile_authorize, :has_to_change_password


	def article_author_date


	end

	def article_author_date_service
		puts "DEBUG #{report_article_author_date['startDate']}"
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		hashResult[:rows] = Article.select("id, title, views").where("created_at >= ? AND created_at <= ? AND status = ? AND created_by_name = ?", report_article_author_date["startDate"], report_article_author_date["endDate"], report_article_author_date["status"], report_article_author_date["authorName"])

		@result.push(hashResult)
		respond_to do |format|
		    format.json { render json: @result }
		end
	end


	private
	def report_article_author_date
		params.require(:request).permit(:startDate, :endDate, :authorName, :status)
	end


end