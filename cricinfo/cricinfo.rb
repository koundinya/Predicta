require 'open-uri'
require 'nokogiri'
require 'json'
require 'elo'

module Cricinfo

	DATA_ENDPOINT = "http://stats.espncricinfo.com/ci/engine/records/team/match_results.html?class=2;type=year;id="

	FIRST_MATCH = 1971

	DRAW = "tied"
	
	NO_RESULT = "no result"

	TEAMS = ['Afghanistan', 'Australia', 'Bangladesh', 'England', 'India', 'New Zealand', 'Pakistan',
	'South Africa', 'Sri Lanka', 'West Indies']

	def self.sync
		puts "Fetching data .... this might take sometime"
		start_time = Time.now
		fetchData(Time.now.year)
		diff = Time.now - start_time
		puts "Sync took #{diff} seconds"	
	end

	def self.fetchData(year)
		html_data = open(DATA_ENDPOINT + year.to_s)
		html_doc = Nokogiri::HTML(html_data)
		result_table = html_doc.at('.engineTable')
		file_name = getFileName(year)
		File.write(file_name, result_table.to_xml)
	end

	def self.getFileName(year)
		year = year.to_s
		return "data/#{year}.xml"
	end

	def self.fetchResultData(year)
		file_name = getFileName(year)
		result_set = File.open(file_name) { |f| Nokogiri::HTML(f) }
		return result_set
	end

	def self.prepareEloTeams()
		elo_teams = []
		TEAMS.each {elo_teams.push(Elo::Player.new)}
		return elo_teams
	end
	
	def self.validTeam?(teamname)
		if TEAMS.index(teamname).nil?
			puts "Invalid team name - #{teamname}"
			return false
		end
		return true
	end

	def self.prediction(ratings,player_team,opponent_team)
		if validTeam?(player_team) && validTeam?(opponent_team) 
			player = ratings[TEAMS.index(player_team)]
			opponent = ratings[TEAMS.index(opponent_team)]
			probability = 1.0/(1 + (10 ** ((opponent.rating - player.rating)/400.0)))
			puts "The odds of winning for #{player_team} are #{probability}"
		end
	end

	def self.calculateRatings
		puts "Syncing data, just in case"
		sync
		elo_teams  = prepareEloTeams
		puts "Calculating ELO ratings..."
		for year in FIRST_MATCH..Time.now.year
			result_set = fetchResultData(year)
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
		puts "ELO ratings calculated!"
		return elo_teams
	end
end

