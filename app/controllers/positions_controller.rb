class PositionsController < ApplicationController
  before_action :set_positions

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
    @players = NflPlayer.all.order(projected_points: :desc)
    @rounds = @players.each_slice(10)
  end

  private

    def set_positions
      @positions = NflPlayer::VALID_POSITIONS.clone.unshift('All')
    end

end
