# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

nfl_teams = CSV.read('db/nfl_teams.csv')

nfl_teams.each do |team|
	t = NflTeam.find_or_create_by(city: team[0], nickname: team[1], shortname: team[2])
	puts "Loading the #{t.nickname}"
end

['QB', 'RB', 'WR', 'TE', 'DEF', 'K'].each do |position|
	players = CSV.read("db/players/#{position.downcase}.csv")
	players.each do |player|
		pl = NflPlayer.find_or_create_by(
			position_rank: player[0].to_i, projected_points: player[1].to_d,
			last_name: player[2], first_name: player[3], position: position,
			nfl_team: NflTeam.where(shortname: player[4]).first
		)
		puts "Loading #{pl.name} - #{pl.position_rank} - #{pl.projected_points}"
	end
end

owners = ['Ian', 'Brandt', 'Lamb', 'Goldson', 'Carlson', 
	'Chuck', 'Kinder', 'Lucas', 'Rodney', 'TBQ']
owners.each_with_index do |owner, i|
	fantasy_team = FantasyTeam.find_or_create_by(owner: owner, pick_number: i + 1)
	puts "\nLoading #{owner}'s draft: "
	picks = []
	(1..16).each do |round|
		offset = round % 2 == 1 ? i + 1 : 10 - i
		pick = (round-1)*10 + offset
		fantasy_team.draft_picks.create(number: pick)
	end

	puts "He gets picks #{fantasy_team.draft_picks.map(&:number)}\n"
end

# keepers
puts

def keep(name, owner)
	first, last = name.split(' ')
	player = NflPlayer.where(first_name: first, last_name: last).first
	FantasyTeam.where(owner: owner).first.draft_picks[3].update(nfl_player: player)
	puts "#{owner} is keeping #{player.name}"
end

keep('Jeremy Hill', 'Rodney')
keep('Mark Ingram', 'Lucas')

# load adp data
puts
puts "Loading ADP data from FFC"

players = CSV.read('db/adp/ffc.csv')
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
		puts "Reading ADP for #{player[2]}: #{player[1].to_f} | #{player[0].to_f}"
		pl.update(adp_ffc: player[1].to_f, adp_round: player[0].to_f)
		puts "Now it is #{pl.adp_ffc} | #{pl.adp_round}"
	end
end

NflPlayer.where(adp_ffc: nil).each do |player|
	player.update(adp_ffc: 170, adp_round: 20.0)
end