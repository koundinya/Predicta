require 'open-uri'
require 'nokogiri'
require 'json'
require 'elo'

module Cricinfo

	DATA_ENDPOINT = "http://stats.espncricinfo.com/ci/engine/records/team/match_results.html?class=2;type=year;id="

	DRAW = "tied"
	
	NO_RESULT = "no result"

	TEAMS = ['Afghanistan', 'Australia', 'Bangladesh', 'England', 'India', 'New Zealand', 'Pakistan',
	'South Africa', 'Sri Lanka', 'West Indies']

	def self.fetchData(year)
		html_data = open(DATA_ENDPOINT + year)
		html_doc = Nokogiri::HTML(html_data)
		result_table = html_doc.at('.engineTable')
		# File.write("data/"+year".xml", result_table.to_xml)
		return result_table
	end

	def self.prepareEloTeams()
		elo_teams = []
		TEAMS.each {elo_teams.push(Elo::Player.new)}
		return elo_teams
	end
	
	def self.calculateData
		elo_teams  = prepareEloTeams
		result_set =  fetchData('2019')
		result_set.search('tr').each do |tr|
			cells = tr.search('th, td')
			home_team = cells[0].text.strip
			away_team = cells[1].text.strip
			result = cells[2].text.strip
			
			# Check if the team is participating in the world cup
			if TEAMS.index(home_team).nil?
				next
			elsif TEAMS.index(away_team).nil? 
				next
			end

			if  result == NO_RESULT		
				next
			elsif result == DRAW
				elo_teams[TEAMS.index(home_team)].plays_draw(elo_teams[TEAMS.index(away_team)])
			elsif home_team.eql? result
				elo_teams[TEAMS.index(home_team)].wins_from(elo_teams[TEAMS.index(away_team)])
			elsif away_team.eql? result
				elo_teams[TEAMS.index(away_team)].wins_from(elo_teams[TEAMS.index(home_team)])
			end
		end
	end
end

		# Calculate probability of winning
		# probability = 1.0/(1 + (10 ** ((elo_teams[2].rating - elo_teams[3].rating)/400.0)))
		# puts "The odds of winning are #{probability}"
		# probability = 1.0/(1 + (10 ** ((elo_teams[3].rating - elo_teams[2].rating)/400.0)))
		# puts "The odds of winning are #{probability}"
