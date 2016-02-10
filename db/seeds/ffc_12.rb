require 'csv'

puts "\nLoading 12 team ADP data from FFC\n\n"
NflPlayer.update_all(adp_ffc: nil, adp_round: nil)

players = CSV.read('db/adp/ffc12.csv')
players.each do |player|
	names = player[2].split(' ')
	if names.last == 'Defense'
		pl = NflPlayer.where(position: 'DEF').joins(:nfl_team).where(
			"nfl_teams.shortname" => player[4]).first	
	else
		first, last = [names[0], names.last(names.count-1).join(' ')] 
		pl = NflPlayer.where(last_name: last, position: player[3]).joins(:nfl_team).where(
			"nfl_teams.shortname" => player[4]).first
	end

	if !pl
		p "#{player[2]} not found!!!"
	else
		pl.update(adp_ffc: player[1].to_f, adp_round: player[0].to_f)
	end
end

NflPlayer.where(adp_ffc: nil).each do |player|
	player.update(adp_ffc: 205, adp_round: 20.0)
end