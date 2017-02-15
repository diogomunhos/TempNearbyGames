class GameCompany < ActiveRecord::Base
	belongs_to :game, foreign_key: :game_id
	belongs_to :company, foreign_key: :company_id


	scope :getPublishersFromGame, -> (game_id = nil) {where("company_type = ? AND game_id = ?", "Publisher", game_id)}
	scope :getDevelopersFromGame, -> (game_id = nil) {where("company_type = ? AND game_id = ?", "Developer", game_id)}
end