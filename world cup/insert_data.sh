#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #GET WINNER TEAM ID
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    #IF NOT FOUND
    if [[ -z $WIN_ID ]]
    then
      #INSERT TEAM
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
      then
        echo Team: $WINNER inserted into teams
      fi
      #GET NEW TEAMID
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi
    #REPEAT FOR OPPONENT
    #GET OPP TEAM ID
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    #IF NOT FOUND
    if [[ -z $OPP_ID ]]
    then
      #INSERT TEAM
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_OPP_RESULT = "INSERT 0 1" ]]
      then
        echo Team: $OPPONENT inserted into teams
      fi
      #GET NEW TEAMID
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
    
    #INSERT YEAR, ROUND, WINNER ID, OPP ID, WINN GOAL, OPP GOALS
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WIN_ID', '$OPP_ID', '$WIN_GOALS', '$OPP_GOALS');")
    echo Game: $WINNER vs. $OPPONENT inserted into games
  fi
done