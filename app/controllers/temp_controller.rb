class TempController < ApplicationController

	def temp
		@document = Document.new
	end

	def create
		Document.initialize(document_params)
	end



	def document_params
		params.require(:document).permit(:file)
	end
end