class ReportsSecuredController < ApplicationController
	layout "admapplication"
	
	before_filter :authorize, :profile_authorize, :has_to_change_password


	def article_author_date
		@users = User.select("id, name, last_name").order("name asc")

	end

	def article_author_date_service
		@result = Array.new
		hashResult = Hash.new
		hashResult[:isSuccessful] = true
		if(report_article_author_date["status"] == 'All')
			hashResult[:rows] = Article.select("id, title, views, created_at").where("created_at >= ? AND created_at <= ? AND created_by_name = ?", report_article_author_date["startDate"], report_article_author_date["endDate"], report_article_author_date["authorName"]).order("created_at asc")
		else
			hashResult[:rows] = Article.select("id, title, views, created_at").where("created_at >= ? AND created_at <= ? AND status = ? AND created_by_name = ?", report_article_author_date["startDate"], report_article_author_date["endDate"], report_article_author_date["status"], report_article_author_date["authorName"]).order("created_at asc")
		end
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