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
Commands:
  predicta.rb fetch                    # Scraps data from Cricinfo and saves
  predicta.rb help [COMMAND]           # Describe available commands or one specific command
  predicta.rb list                     # Lists teams in CWC2019
  predicta.rb predict [TEAM1] [TEAM2]  # Predicts the outcome of a match

```

## Todo
1. TEST CASES -- RSPECS.
2. BUILD SHEILDS

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)