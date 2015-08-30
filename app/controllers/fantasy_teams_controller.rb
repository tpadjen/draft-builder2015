class FantasyTeamsController < LeaguesViewController
	around_action :skip_bullet, only: [:show]

	def show
		puts "In show"
		p params
		if !params[:owner]
			redirect_to(:back)
		else
			@fantasy_team = FantasyTeam.from_owner(owner)
			if @fantasy_team
				@picks, @starters, @bench = @fantasy_team.roster
			else
				redirect_to(:back) 
			end
		end
	rescue ActionController::RedirectBackError
  	redirect_to root_path
	end

	def edit
		
	end

end
