class TempController < ApplicationController
	before_filter :authorize

	def temp
		@document = Document.new
		@advertising = Advertising.new
	end

	def create
		Document.initialize(document_params)
	end

	def advertising_params
		params.require(:advertising).permit(:html_body)
	end

	def document_params
		params.require(:document).permit(:file)
	end
end