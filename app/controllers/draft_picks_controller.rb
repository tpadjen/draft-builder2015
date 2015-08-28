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

  private

end
