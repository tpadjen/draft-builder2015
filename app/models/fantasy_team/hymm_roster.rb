class FantasyTeam::HymmRoster < FantasyTeam::Roster
	
	@@starting_spots = {
		'QB' 		=>  1,
		'RB' 		=>  1,
		'WR' 		=>  2,
		'FLEX|RB|WR' =>  1,
		'TE'    =>  1,
		'DEF'   =>  1,
		'K'     =>  1
	}

end