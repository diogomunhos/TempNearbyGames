class Company < ActiveRecord::Base
	has_many :game_companies, foreign_key: :company_id, dependent: :destroy
	has_many :games, through: :game_companies

	scope :getCompanyPaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('name') } 
end
