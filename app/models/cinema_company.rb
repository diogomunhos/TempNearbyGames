class CinemaCompany < ActiveRecord::Base
	belongs_to :cinema, foreign_key: :cinema_id
	belongs_to :company, foreign_key: :company_id

end