#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# header exclusion
  if [[ $YEAR != "year" ]]
  then
    # get teams ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found insert
    if [[ -z $WINNER_ID && -z $OPPONENT_ID ]]
    then
      IWO=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER'),('$OPPONENT')")
      echo $IWO $WINNER $OPPONENT
    elif [[ -z $WINNER_ID && ! -z $OPPONENT_ID ]]
    then
      IW=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $IW $WINNER 
    elif [[ ! -z $WINNER_ID && -z $OPPONENT_ID ]]
    then
      IO=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $IO $OPPONENT
    fi

    # get new id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # populate game table
    IG=$($PSQL "INSERT INTO games(year, round,winner_id, opponent_id,winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo $IG game

  fi
done