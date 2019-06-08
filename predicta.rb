#!/usr/bin/env ruby

require_relative './cricinfo/cricinfo.rb'

require "thor"
 
class PredictaCLI < Thor
	desc "fetch", "Scraps data from Cricinfo and saves"
	def fetch
		Cricinfo.sync
	end

	desc "predict [TEAM1] [TEAM2]", "Predicts the outcome of a match"
	def predict(team1,team2)
		ratings = Cricinfo.calculateRatings
		Cricinfo.prediction(ratings,team1,team2)
	end

	desc "list" , "Lists teams in CWC2019" 
	def list
		Cricinfo.list_teams
	end
end
 
PredictaCLI.start(ARGV)




