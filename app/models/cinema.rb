class Cinema < ActiveRecord::Base
	has_many :cinema_companies, foreign_key: :cinema_id, dependent: :destroy
	has_many :companies, through: :cinema_companies

end