class FantasyTeamsController < ApplicationController

	def show
		if !params[:owner]
			redirect_to(:back)
		else
			@fantasy_team = FantasyTeam.where('lower(owner) = ?', params[:owner].downcase).includes(
				:nfl_players, :draft_picks).first
			redirect_to(:back) unless @fantasy_team
		end
	rescue ActionController::RedirectBackError
  	redirect_to root_path
	end

end
