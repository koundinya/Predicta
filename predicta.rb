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
		Cricinfo.list_teams
	end

	desc "fetchFixtures", "Scraps fixture data"
	def fetchFixtures
		Cricinfo.fetchFixtures
	end

	desc "fetchTodaysFixture", "Scraps fixture data"
	def fetchTodaysFixture
		fixture = Cricinfo.fetchTodaysFixture
		puts fixture
	end

end
 
PredictaCLI.start(ARGV)




