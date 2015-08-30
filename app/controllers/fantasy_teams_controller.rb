class FantasyTeamsController < LeaguesViewController
	around_action :skip_bullet, only: [:show]

	def show
		if @fantasy_team = FantasyTeam.from_owner(params[:owner] || nil)
			@picks, @starters, @bench = @fantasy_team.roster
		else
			redirect_to(:back) 
		end
	rescue ActionController::RedirectBackError
  	redirect_to root_path
	end

	def edit
		
	end

end
