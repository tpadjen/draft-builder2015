class PositionsController < ApplicationController

  def index
    if params[:position] && !NflPlayer.position_valid?(params[:position])
      redirect_to root_path
    end

    if params[:position]
      @position = params[:position].upcase
      @players = NflPlayer.where(position: @position).includes(:fantasy_team).includes(:nfl_team).order(projected_points: :desc)
    else
      @position = 'All'
      @players = NflPlayer.all.includes(:fantasy_team).includes(:nfl_team).order(:adp_ffc)
    end

    if params[:rank] && params[:rank] == 'points'
      @points = true
      @players = @players.reorder(projected_points: :desc)
    else
      @adp = true
    end
  end

end
