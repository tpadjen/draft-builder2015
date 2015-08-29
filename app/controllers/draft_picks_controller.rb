class DraftPicksController < ApplicationController
  
  def pick
    if !@current_pick
      render json: "Draft over", status: 401
    else
    	if params[:player] && player = NflPlayer.find(params[:player][:id].to_i)
    		if @current_pick.update(nfl_player: player)
    			render json: {
    				current_pick: @current_pick.to_json, 
    				next_pick: current_pick.to_json 
          }, status: 200
    		else
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
      message = "#{owner}'s selection of #{player.name} has been undone."
      respond_to do |format|
        format.html do
          flash[:success] = message
          redirect_to :back   
        end
        format.json do
          render json: {
            message: message,
            current_pick: @current_pick.to_json, 
            prev_pick: current_pick.to_json 
          }, status: 200 
        end
      end
      
    else
      message = "No picks have been made."
      respond_to do |format|
        format.html do
          flash[:error] = message
          redirect_to :back    
        end
        format.json do
          render json: message, status: :unprocessable_entity
        end
      end
      
    end
  end

  private

end
