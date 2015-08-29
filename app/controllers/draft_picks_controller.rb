class DraftPicksController < ApplicationController
  
  def pick
    if !@current_pick
      render json: "Draft over", status: 401
    else
    	if params[:player] && player = NflPlayer.find(params[:player][:id].to_i)
    		if @current_pick.update(nfl_player: player)
    			render json: {
    				current_pick: @current_pick.to_json, 
    				next_pick: current_pick.to_json }, status: 200
    		else
    			p 'ERRORS'
    			print @current_pick.errors
    			render json: @current_pick.errors, status: :unprocessable_entity
    		end
    	end
    end
  end

  def undo
    if DraftPick.first.selected?
      pick = DraftPick.selected.where.not(keeper: true).order(:number).last
      player = pick.nfl_player
      owner = pick.fantasy_team.owner
      pick.update(nfl_player: nil)
      flash[:notice] = "#{owner}'s selection of #{player.name} has been undone."
      redirect_to :back
    else
      flash[:error] = "No picks have been made."
      redirect_to :back
    end
  end

  private

end
