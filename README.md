# Predicta

Predicta is a Ruby CLI Application that uses the ELO rating system to predict results for the Cricket World Cup 2019.

## Background

https://fivethirtyeight.com/methodology/how-our-nfl-predictions-work/

https://en.wikipedia.org/wiki/Elo_rating_system


## Installation

### Pre-requisites 
1. Ruby
2. Bundler

```bash
# Run make in the cloned directory. 
make 
```

## Usage

```bash
predicta.rb fetch                    # Scraps data from Cricinfo and saves
  predicta.rb fetchFixtures            # Scraps fixture data
  predicta.rb fetchTodaysFixture       # Scraps fixture data
  predicta.rb help [COMMAND]           # Describe available commands or one specific command
  predicta.rb list                     # Lists teams in CWC2019
  predicta.rb predict [TEAM1] [TEAM2]  # Predicts the outcome of a match
  predicta.rb todaysPrediction         # Predicts results for today's match/matches

```

## Example

```bash
./predicta.rb predict England Bangladesh


Syncing data, just in case
Fetching data .... this might take sometime
Sync took 1.273706 seconds
Calculating ELO ratings...
ELO ratings calculated!
England has a 75.34% chance of winning.
Bangladesh has a 24.66% chance of winning.


```

## Todo
1. TEST CASES -- RSPECS.
2. BUILD SHEILDS
3. cricinfo.rb is a module where I've dumped all my logic. Doesn't look good, should find a better way to split concerns. Example of why its ugly ~ Ideally it should be just returning results and the CLI file predicta.rb should be deciding if it should be printed on console or not. Print statements are across classes. 🤮
4. Logic - Need to factor in new teams vs old teams using K factor. Example afghanistan should have a different K value compared to Australia / England. 
5. Docker + Web App

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)