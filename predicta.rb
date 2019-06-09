#!/usr/bin/env ruby

require_relative './cricinfo/cricinfo.rb'

require "thor"
 
class PredictaCLI < Thor
	desc "fetch", "Scraps data from Cricinfo and saves"
	def fetch
		Cricinfo.sync
	end

	desc "predict [TEAM1] [TEAM2]", "Predicts the outcome of a match"
	def predict(home,away)
		ratings = Cricinfo.calculateRatings
		result = Cricinfo.prediction(ratings,home,away)
		puts "#{home} has a #{result[:home]}% chance of winning"
		puts "#{away} has a #{result[:away]}% chance of winning"
	end

	desc "list" , "Lists teams in CWC2019" 
	def list
		teams = Cricinfo.list_teams
		ratings = Cricinfo.calculateRatings
		results = []
		teams.each_with_index do |team,index|
			results.push({team: team, rating: ratings[index].rating})
		end
		results = results.sort_by{|result| result[:rating]}.reverse
		results.each do |result| 
			puts "#{result[:team]} -- #{result[:rating]}"
		end
	end

	desc "fetchFixtures", "Scraps fixture data"
	def fetchFixtures
		Cricinfo.fetchFixtures
	end

	desc "fetchTodaysFixture", "Scraps fixture data"
	def fetchTodaysFixture
		fixtures = Cricinfo.fetchTodaysFixture
		puts fixtures
	end

	desc "todaysPrediction", "Predicts results for today's match/matches"
	def todaysPrediction
		fixtures = Cricinfo.fetchTodaysFixture
		fixtures.each do |fixture| 
			predict(fixture[:home],fixture[:away])
		end
	end

end
 
PredictaCLI.start(ARGV)




