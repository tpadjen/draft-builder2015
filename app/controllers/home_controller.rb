class HomeController < ApplicationController

	def index
		@positions = NflPlayer::VALID_POSITIONS.clone.unshift('All')
	end

end
