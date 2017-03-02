class Cinema < ActiveRecord::Base
	has_many :cinema_companies, foreign_key: :cinema_id, dependent: :destroy
	has_many :companies, through: :cinema_companies

	accepts_nested_attributes_for :cinema_companies
	accepts_nested_attributes_for :companies

	scope :getCinemaWithCompaniesById, -> (cinema_id = nil) { where(id: cinema_id).limit(1).includes(:companies) }
	scope :getCinemaPaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllCinemasSearchByField, -> (fieldToSearch = nil, searchValue = nil, numberPerPage = nil, offset_page = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllCinemasSearchByFieldCount, -> (fieldToSearch = nil, searchValue = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").count }
	scope :getCinemaByPlatform, -> (platform = nil) {where("platform LIKE ? ", "%#{platform}%").limit(50).order("created_at DESC").includes(:companies)}
end