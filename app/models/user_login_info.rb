class UserLoginInfo < ActiveRecord::Base
	belongs_to :user, foreign_key: :user_id


	def send_password_reset
	  generate_password_reset_token(:reset_password_token)
	  self.reset_request_date = Date.new
	  save!
	  UserMailer.password_reset(self.user_id).deliver
	end


	def generate_password_reset_token(column)
		begin
		    self[column] = SecureRandom.urlsafe_base64
		  end while UserLoginInfo.exists?(column => self[column])
	end

end