class FantasyTeamsController < LeaguesViewController
	around_action :skip_bullet, only: [:show]

	def show
		puts "In show"
		p params
		if !params[:owner]
			redirect_to(:back)
		else
			@fantasy_team = FantasyTeam.where(
				'lower(owner) = ?', params[:owner].downcase).first
			if @fantasy_team
				@picks = @fantasy_team.draft_picks.includes(nfl_player: :nfl_team).order(:number)
				@selected = @picks.selected
				build_roster
			else
				redirect_to(:back) 
			end
		end
	rescue ActionController::RedirectBackError
  	redirect_to root_path
	end

	def edit
		
	end

	private

		def build_roster
			@starters = {}
			@bench = {
				'QB' => [],
				'RB' => [],
				'WR' => [],
				'TE' => [],
				'DEF' => [],
				'K' => []
			}

			@selected.each do |pick|
				player = pick.nfl_player
				if ['QB', 'TE', 'DEF', 'K'].include?(player.position)
					if @starters.key?(player.position)
						@bench[player.position] << player
					else
						@starters[player.position] = player
					end
				elsif player.position == 'RB'
					if @starters.key?('RB1')
						if @starters.key?('RB2') || @starters.key?('WR3')
							@bench['RB'] << player
						else
							@starters['RB2'] = player	
						end
					else
						@starters['RB1'] = player
					end
				else # WR
					if @starters.key?('WR1')
						if @starters.key?('WR2')
							if @starters.key?('WR3') || @starters.key?('RB2')
								@bench['WR'] << player
							else
								@starters['WR3'] = player
							end
						else
							@starters['WR2'] = player	
						end
					else
						@starters['WR1'] = player
					end
				end
			end

		end

end
