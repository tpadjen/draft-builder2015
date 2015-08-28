class PositionsController < ApplicationController

  def index
    if params[:position] && !NflPlayer.position_valid?(params[:position])
      redirect_to root_path
    end

    if params[:position]
      @position = params[:position].upcase
      @players = NflPlayer.where(position: @position).includes(:fantasy_team).order(projected_points: :desc)
    else
      @position = 'All'
      @players = NflPlayer.all.includes(:fantasy_team).order(projected_points: :desc)
    end

    if params[:rank] && params[:rank] == 'adp'
      @adp = true
      @players = @players.reorder(:adp_ffc)
    else
      @points = true
    end
  end

end
