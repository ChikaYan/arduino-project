import de.bezier.data.sql.*;

String dbHost = "localhost";
String dbPort = "3306";
String dbUser = "testuser";
String dbPass = "998182aaa";
String dbName = "test";
String tableName = "scoreboard";

MySQL msql;

void setup(){
  int score = 3000;
  String name = "test5";
  msql = new MySQL(this, dbHost + ":" + dbPort,dbName,dbUser,dbPass);
  int ranking = 1;
  Boolean foundPosition = false;

  if (msql.connect()){
    msql.query("SELECT * FROM scoreboard ORDER BY rank");
    while(msql.next() && foundPosition == false){
      if (int(msql.getString("score")) < score){
        //find inserting position
        ranking = int(msql.getString("rank"));
        foundPosition = true;
      }
      if (foundPosition){
        msql.query("UPDATE scoreboard SET rank = rank + 1 WHERE rank >= " + str(ranking));
        msql.query("INSERT INTO scoreboard (rank, score, name) VALUES(" + str(ranking) + ", " + str(score)+ ", \" " + name + " \")");
      }
    }

    if (!foundPosition){
      msql.query("SELECT * FROM scoreboard ORDER BY rank");
      if (msql.next()){
        msql.query("SELECT MAX(rank) FROM scoreboard");
        msql.next();
        ranking = int(msql.getString("MAX(rank)")) + 1;
      }
      msql.query("INSERT INTO scoreboard (rank, score, name) VALUES(" + str(ranking) + ", " + str(score)+ ", \" " + name + " \")");
    }


    msql.query("SELECT * FROM scoreboard ORDER BY rank");
    while(msql.next()){
      println(msql.getString("rank") + "  " + msql.getString("score") + " " + msql.getString("name"));
    }
  }




}
