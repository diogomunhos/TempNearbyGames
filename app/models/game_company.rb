class GameCompany < ActiveRecord::Base
	belongs_to :game, foreign_key: :game_id
	belongs_to :company, foreign_key: :company_id
end
