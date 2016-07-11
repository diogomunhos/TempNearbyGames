class AdvertisingController < ApplicationController

	def create 
		Document.create(id_active: true, position: 1, html_body: '<div style="width: 100%; position: relative; margin-top: 10px;">
		<img src="https://s.dynad.net/stack/4BgnrAZSVmtsYZEoVHY3LVIHRm6n4DYLj_gEGn1ccdE.gif" style="width: 100%;">
	</div>', is_default: true)
		
	end

	def show
		redirect_to "/temp"
	end

end