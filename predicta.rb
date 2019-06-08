#!/usr/bin/env ruby

require_relative './cricinfo/cricinfo.rb'

require "thor"
 
class PredictaCLI < Thor
	desc "fetch", "Scraps data from Cricinfo and saves"
	def fetch
		Cricinfo.sync
	end

	desc "predict Australia Bangladesh", "Predicts the outcome of a match"
	def predict(team1,team2)
		ratings = Cricinfo.calculateRatings
		Cricinfo.prediction(ratings,team1,team2)
	end
end
 
PredictaCLI.start(ARGV)




