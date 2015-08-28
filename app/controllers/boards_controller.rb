class BoardsController < ApplicationController

  def draft
  	@picks = DraftPick.all.includes(:nfl_player).order(:number)
  	@rounds = @picks.each_slice(10)
  end

  def adp
  	@players = NflPlayer.all.includes(:fantasy_team).order(:adp_ffc)
  	@rounds = @players.each_slice(10)
  end

  def points
  	@players = NflPlayer.all.includes(:fantasy_team).order(projected_points: :desc)
  	@rounds = @players.each_slice(10)
  end
end
