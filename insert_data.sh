#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#adding teams to teams database
cat games.csv | while IFS="," read -r  YEAR ROUND WINNER OPPONENT WGOAL OGOAL
do 
  if [[ $WINNER == "winner" ]];
  then
    continue
  else 
    TEAM1_EXIST=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    TEAM2_EXIST=$($PSQL "SELECT name FROM teams where name = '$OPPONENT'")
    if [[ -z $TEAM1_EXIST ]]
      then
      INSERT_TEAM1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    if [[ -z $TEAM2_EXIST ]]
      then
      INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    #add games to games db
    GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$GET_WINNER_ID','$GET_OPPONENT_ID','$WGOAL','$OGOAL')")
  fi
done
