class HomeController < ApplicationController

	def index
		@positions = NflPlayer::VALID_POSITIONS.clone.unshift('All')
		@position = 'All'
	end

end
