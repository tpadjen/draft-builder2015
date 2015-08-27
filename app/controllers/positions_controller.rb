class PositionsController < ApplicationController
  
  def index
    if params[:position] && !NflPlayer.position_valid?(params[:position])
      redirect_to '/pos'
    end

    if params[:position]
      @position = params[:position].upcase
      @players = NflPlayer.where(position: @position).order(projected_points: :desc)
    else
      @position = "All Players"
      @players = NflPlayer.all.order(projected_points: :desc)
    end
  end

end
