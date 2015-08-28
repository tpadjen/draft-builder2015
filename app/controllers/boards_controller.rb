class BoardsController < ApplicationController

  def draft
  	@picks = DraftPick.all.order(:number)
  	@rounds = @picks.each_slice(10)
  end

  def adp
  	@players = NflPlayer.all.order(:adp_ffc)
  	@rounds = @players.each_slice(10)
  end

  def points
  	@players = NflPlayer.all.order(projected_points: :desc)
  	@rounds = @players.each_slice(10)
  end
end
