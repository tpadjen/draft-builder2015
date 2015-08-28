class PositionsController < ApplicationController

  def index
    if params[:position] && !NflPlayer.position_valid?(params[:position])
      redirect_to root_path
    end

    if params[:position]
      @position = params[:position].upcase
      @players = NflPlayer.where(position: @position).order(projected_points: :desc)
    else
      @position = 'All'
      @players = NflPlayer.all.order(projected_points: :desc)
    end
  end

  def board
    @board = true
    if params[:style]
      if ['adp', 'points'].include?(params[:style].downcase)
        if params[:style].downcase == 'points'
          @players = NflPlayer.all.order(projected_points: :desc)
        elsif params[:style].downcase == 'adp'
          @players = NflPlayer.all.order(:adp)
        end
      else
        redirect_to '/board'
      end
    else # projected points
      @players = DraftPick.selected.map {|pick| pick.nfl_player }
    end
    @rounds = @players.each_slice(10)
  end

end
