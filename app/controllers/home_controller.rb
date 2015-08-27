class HomeController < ApplicationController

	def index
		@players = NflPlayer.all.order(projected_points: :desc)
	end

end
