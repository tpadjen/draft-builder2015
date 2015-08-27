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