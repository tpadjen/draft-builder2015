class BoardsController < ApplicationController

  def draft
  	@players = DraftPick.selected.map {|pick| pick.nfl_player }
  	@rounds = @players.each_slice(10)
  end

  def adp
  	@players = NflPlayer.all.order(:adp)
  	@rounds = @players.each_slice(10)
  end

  def points
  	@players = NflPlayer.all.order(projected_points: :desc)
  	@rounds = @players.each_slice(10)
  end
end
