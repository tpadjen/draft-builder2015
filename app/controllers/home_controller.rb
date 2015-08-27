class HomeController < ApplicationController

	def index
		@positions = NflPlayer.valid_positions.unshift('All')
	end

end
