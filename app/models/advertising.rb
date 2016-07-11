class Advertising < ActiveRecord::Base
	scope :getAdvertisingByPosition, -> (position = nil) { where(postion: position).where(is_active: true).where(is_default: false).limit(1)}
	scope :getDefaultAdvertising, -> { where(is_active: true).where(is_default: true).limit(1) }
end