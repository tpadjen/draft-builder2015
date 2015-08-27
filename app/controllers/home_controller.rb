class HomeController < ApplicationController

	def index
		if params[:pos] && NflPlayer.position_valid?(params[:pos])
			@position = params[:pos].upcase
			@players = NflPlayer.where(position: @position).order(projected_points: :desc)
		elsif params[:pos] && params[:pos].downcase == 'all'
			@position = "All Players"
			@players = NflPlayer.all.order(projected_points: :desc)
		end
	end

end
