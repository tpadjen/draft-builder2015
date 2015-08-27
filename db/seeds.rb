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