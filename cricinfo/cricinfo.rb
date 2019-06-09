require 'open-uri'
require 'nokogiri'
require 'json'
require 'elo'

module Cricinfo
	
	DATA_ENDPOINT = "http://stats.espncricinfo.com/ci/engine/records/team/match_results.html?class=2;type=year;id="

	FIXTURES_ENDPOINT = "https://www.firstpost.com/firstcricket/cricket-schedule/series/icc-cricket-world-cup-2019.html"

	FIRST_MATCH = 1971

	DRAW = "tied"
	
	NO_RESULT = "no result"

	TEAMS = ['Afghanistan', 'Australia', 'Bangladesh', 'England', 'India', 'NewZealand', 'Pakistan',
	'SouthAfrica', 'SriLanka', 'WestIndies']

	FIXTURE_FILE_NAME = "data/fixtures.xml"

	def self.list_teams
		puts TEAMS
	end

	def self.sync
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

	def self.calculatePercentage(team1,team2)
		value = 1.0/(1 + (10 ** ((team1.rating - team2.rating)/400.0)))
		value = value * 100
		return value.round(2)
	end

	def self.prediction(ratings,home_team,away_team)
		if validTeam?(home_team) && validTeam?(away_team) 
			home = ratings[TEAMS.index(home_team)]
			away = ratings[TEAMS.index(away_team)]
			homeWinPercentage = calculatePercentage(away,home)
			awayWinPercentage = calculatePercentage(home,away)
			result = {:home => homeWinPercentage, :away => awayWinPercentage}
			return result
		end
	end

	def self.fetchFixtures
		html_data = open(FIXTURES_ENDPOINT)
		html_doc = Nokogiri::HTML(html_data)
		result_table = html_doc.at('.table')
		File.write(FIXTURE_FILE_NAME, result_table.to_xml)
	end

	def self.fetchTodaysFixture
		fixtures = []
		result_table = File.open(FIXTURE_FILE_NAME) { |f| Nokogiri::HTML(f) }
		result_table.search('tr').each do |tr|
			cell = tr.search('th, td')
			fixtureTime = Time.parse(cell[0])
			currentTime = Time.now
			if currentTime.day == fixtureTime.day && currentTime.month == fixtureTime.month
				fixtures.push(getHomeAndAway(cell[1].at_css('.summary').text))
			end
		end
		return fixtures
	end

	def self.getHomeAndAway(fixString)
		home = fixString.split("vs")[0].strip.delete(' ')
		away = fixString.split("vs")[1].strip.delete(' ')
		return {:home => home, :away => away}
	end


	def self.calculateRatings
		sync
		elo_teams  = prepareEloTeams
		for year in FIRST_MATCH..Time.now.year
			result_set = fetchResultData(year)
			result_set.search('tr').each do |tr|
				cells = tr.search('th, td')
				home_team = cells[0].text.strip.delete(' ')
				away_team = cells[1].text.strip.delete(' ')
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
		return elo_teams
	end
end

