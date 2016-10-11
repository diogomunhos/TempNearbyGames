class Game < ActiveRecord::Base
	has_many :game_companies, foreign_key: :game_id, dependent: :destroy
	has_many :companies, through: :game_companies

	accepts_nested_attributes_for :game_companies
	accepts_nested_attributes_for :companies

	scope :getGameWithCompaniesById, -> (game_id = nil) { where(id: game_id).limit(1).includes(:companies) }
	scope :getGamePaged, -> (numberPerPage = nil, offset_page = nil) { offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllGamesSearchByField, -> (fieldToSearch = nil, searchValue = nil, numberPerPage = nil, offset_page = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").offset(offset_page).limit(numberPerPage).order('updated_at DESC') }
	scope :getAllGamesSearchByFieldCount, -> (fieldToSearch = nil, searchValue = nil) { where("#{fieldToSearch} LIKE ? ", "%#{searchValue}%").count }
	scope :getGameByPlatform, -> (platform = nil) {where("platform LIKE ? ", "%#{platform}%").limit(50).order("created_at DESC").includes(:companies)}
end
