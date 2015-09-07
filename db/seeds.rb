# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

nfl_teams = CSV.read('db/nfl_teams.csv')

puts "\nLoading NFL Teams"
nfl_teams.each do |team|
	t = NflTeam.find_or_create_by(
		city: team[0], 
		nickname: team[1], 
		shortname: team[2], 
		bye: team[3].to_i
	)
	# puts "Loading the #{t.nickname}"
end

puts "\nLoading NFL Players"
['QB', 'RB', 'WR', 'TE', 'DEF', 'K'].each do |position|
	players = CSV.read("db/players/#{position.downcase}.csv")
	players.each do |player|
		pl = NflPlayer.find_or_create_by(
			position_rank: player[0].to_i, projected_points: player[1].to_d,
			last_name: player[2], first_name: player[3], position: position,
			nfl_team: NflTeam.where(shortname: player[4]).first
		)
	end
end

# keepers
# puts
# def keep(name, owner)
# 	first, last = name.split(' ')
# 	player = NflPlayer.where(first_name: first, last_name: last).first
# 	FantasyTeam.where(owner: owner).first.draft_picks[3].update(nfl_player: player, keeper: true)
# 	puts "#{owner} is keeping #{player.name}"
# end

# keep('Jeremy Hill', 'Rodney')
# keep('Mark Ingram', 'Lucas')

# load adp data
puts "\nLoading ADP data from FFC\n\n"
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
		pl.update(adp_ffc: player[1].to_f, adp_round: player[0].to_f)
	end
end

NflPlayer.where(adp_ffc: nil).each do |player|
	player.update(adp_ffc: 170, adp_round: 20.0)
end

puts "\nLoading ADP data from ESPN\n\n"
File.open('db/adp/espn.txt', "r") do |f|
  f.each_line do |line|
    names, data = line.split(',').map { |part| part.strip.split(' ') }
    if names.last == 'D/ST'
			pl = NflPlayer.where(position: 'DEF').joins(:nfl_team).where(
				"nfl_teams.shortname" => data[1].upcase).first	
		else
			first, last = [names[0], names.last(names.count-1).join(' ')] 
			pl = NflPlayer.where(last_name: last, position: data[1]).joins(:nfl_team).where(
				"nfl_teams.shortname" => data[0].upcase).first
		end

		if !pl
			p "#{names.join(' ')} not found!!!"
		else
			pl.update(adp_espn: data[2].to_f)
		end

	end
end

NflPlayer.where(adp_espn: nil).each do |player|
	player.update(adp_espn: 201)
end

puts "\nLoading ADP data from Yahoo\n\n"
players = CSV.read('db/adp/yahoo.csv')
players.each do |player|
	
	if player[3] == 'DEF'
		pl = NflPlayer.where(position: 'DEF').joins(:nfl_team).where(
			"nfl_teams.shortname" => player[4]).first	
	else
		pl = NflPlayer.where(last_name: player[2], position: player[3]).joins(:nfl_team).where(
			"nfl_teams.shortname" => player[4]).first
	end

	if !pl
		p player
		# p "#{player[1] + " " + player[2]} not found!!!"
	else
		pl.update(adp_yahoo: player[0].to_f)
	end
end

NflPlayer.where(adp_yahoo: nil).each do |player|
	player.update(adp_yahoo: 240)
end

# Create If It Bleeds You Can Kill It
teams = [
	{
		name: "Hernandez’...", 
		owner: "MattC", 
		picks: ["1.1", "2.12", "3.1", "4.12", "5.1", "6.12", "7.1", "8.12", 
			"9.1", "10.12", "11.1", "12.12", "13.1", "14.12", "15.1", "16.12"],
		keeper: {
			first_name: 'Calvin',
			last_name: 'Johnson',
			position: 'WR',
			team: 'DET',
			pick: '1.1'
		}
	},
	{
		name: "ARC LIGHT",
		owner: "Eric",
		picks: ["1.2", "2.11", "3.2", "4.11", "5.2", "5.4", "6.11", "7.2", 
			"8.11", "10.11", "11.2", "12.11", "13.2", "14.11", "15.2", "16.11"],
		keeper: {
			first_name: 'DeAndre',
			last_name: 'Hopkins',
			position: 'WR',
			team: 'HOU',
			pick: '8.11'
		}
	},
	{
		name: "The Sexy Rex...",
		owner: "Jeremy",
		picks: ["1.3", "2.10", "3.3", "4.10", "5.3", "6.10", "7.3", "8.10", 
			"9.3", "10.10", "11.3", "12.10", "13.3", "14.10", "15.3", "16.10"],
		keeper: {
			first_name: 'Sammy',
			last_name: 'Watkins',
			position: 'WR',
			team: 'BUF',
			pick: '8.10'
		}
	},
	{
		name: "It Ertz When...",
		owner: "Nick",
		picks: ["1.4", "2.9", "4.9", "6.9", "7.4", "8.9", "9.2", "9.4", 
			"9.5", "10.9", "11.4", "12.9", "13.4", "14.9", "15.4", "16.9"],
		keeper: {
			first_name: 'Latavius',
			last_name: 'Murray',
			position: 'RB',
			team: 'OAK',
			pick: '16.9'
		}
	},
	{
		name: "Dat Ass Doe",
		owner: "Tim",
		picks: ["1.5", "2.8", "3.4", "3.5", "4.8", "5.5", "6.8", "7.5", 
			"8.8", "10.8", "11.5", "12.8", "13.5", "14.8", "15.5", "16.8"],
		keeper: {
			first_name: 'Brandin',
			last_name: 'Cooks',
			position: 'WR',
			team: 'NO',
			pick: '8.8'
		}
	},
	{
		name: "Tatted Up",
		owner: "Ashley",
		picks: ["1.6", "2.7", "3.6", "4.7", "5.6", "6.7", "7.6", "8.7", 
			"9.6", "10.7", "11.6", "12.7", "13.6", "14.7", "15.6", "16.7"],
		keeper: {
			first_name: 'Martellus',
			last_name: 'Bennett',
			position: 'TE',
			team: 'CHI',
			pick: '12.7'
		}
	},
	{
		name: "Just the Tip",
		owner: "Sam",
		picks: ["1.7", "2.6", "3.7", "4.6", "5.7", "6.6", "7.7", "8.6", 
			"9.7", "10.6", "11.7", "12.6", "13.7", "14.6", "15.7", "16.6"],
		keeper: {
			first_name: 'Ben',
			last_name: 'Roethlisberger',
			position: 'QB',
			team: 'PIT',
			pick: '11.7'
		}
	},
	{
		name: "HULKSMASH",
		owner: "Dave Lewis",
		picks: ["1.8", "2.5", "3.8", "4.5", "5.8", "6.5", "7.8", "8.5", 
			"9.8", "10.5", "11.8", "12.5", "13.8", "14.5", "15.8", "16.5"],
		keeper: {
			first_name: 'Odell',
			last_name: 'Beckham Jr.',
			position: 'WR',
			team: 'NYG',
			pick: '16.5'
		}
	},
	{
		name: "Airless Balls",
		owner: "Jason",
		picks: ["1.9", "2.4", "3.9", "4.4", "5.9", "6.4", "7.9", "8.4", 
			"9.9", "10.4", "11.9", "12.4", "13.9", "14.4", "15.9", "16.4"],
		keeper: {
			first_name: 'Aaron',
			last_name: 'Rodgers',
			position: 'QB',
			team: 'GB',
			pick: '1.9'
		}
	},
	{
		name: "↑↑↓↓...",
		owner: "Cody",
		picks: ["1.10", "2.3", "3.10", "4.3", "5.10", "6.3", "7.10", "8.3", 
			"9.10", "10.3", "11.10", "12.3", "13.10", "14.3", "15.10", "16.3"],
		keeper: {
			first_name: 'Jeremy',
			last_name: 'Hill',
			position: 'RB',
			team: 'CIN',
			pick: '14.3'
		}

	},
	{
		name: "Tecmo Super ...",
		owner: "Brian",
		picks: ["1.11", "2.2", "3.11", "4.2", "5.11", "6.2", "7.11", "8.2", 
			"9.11", "10.2", "11.11", "12.2", "13.11", "14.2", "15.11", "16.2"],
		keeper: {
			first_name: 'Andrew',
			last_name: 'Luck',
			position: 'QB',
			team: 'IND',
			pick: '4.2'
		}
	},
	{
		name: "Beats by Ray",
		owner: "Grant Carson",
		picks: ["1.12", "2.1", "3.12", "4.1", "5.12", "6.1", "7.12", "8.1", 
			"9.12", "10.1", "11.12", "12.1", "13.12", "14.1", "15.12", "16.1"],
		keeper: {
			first_name: 'Jordan',
			last_name: 'Matthews',
			position: 'WR',
			team: 'PHI',
			pick: '16.1'
		}
	}
]

# League.where(name: "IIBYCKI").first.delete
league = League.create(name: "IIBYCKI", size: 12, roster_style: :if_it_bleeds_you_can_kill_it)

teams.each_with_index do |team, i|
  fantasy_team = league.fantasy_teams.create(owner: team[:owner], name: team[:name], pick_number: i+1)
  team[:picks].each do |pick|
  	round, order = pick.split('.').map(&:to_i)
  	n = (round-1)*teams.count + order
  	league.draft_picks.create(number: n, fantasy_team: fantasy_team)
  end

  player = NflPlayer.where(first_name: team[:keeper][:first_name], 
  													last_name: team[:keeper][:last_name]).first

  if !player || player.nfl_team.shortname != team[:keeper][:team]
  	puts "Could not keep #{team[:keeper][:last_name]}!!!"
  else
  	round, order = team[:keeper][:pick].split('.').map(&:to_i)
  	n = (round-1)*teams.count + order
  	fantasy_team.draft_picks.where(number: n).first.update(nfl_player: player, keeper: true)
  end

 end

['3.4', '9.5', '5.4', '9.2'].each do |pick|
	round, order = pick.split('.').map(&:to_i)
  n = (round-1)*teams.count + order
  league.draft_picks.where(number: n).first.update(traded: true)
end
 