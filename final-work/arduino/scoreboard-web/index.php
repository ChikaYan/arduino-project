<!-- Online scoreboard web page for Arduino coursework
Create by Walter at 05/11/17 -->

<!-- table style comes from https://www.w3schools.com/html/tryit.asp?filename=tryhtml_table_intro-->

<html lang="en">
    <head>
        <title>Bullet Hell Arduino Online Scoreboard</title>
    </head>
    <style>
    table {
        font-family: arial, sans-serif;
        border-collapse: collapse;
        width: 100%;
    }
    td, th {
        border: 1px solid #dddddd;
        text-align: left;
        padding: 8px;
    }
    tr:nth-child(even) {
        background-color: #dddddd;
    }
    </style>
    <body>
        <table>
            <tr>
              <th>Ranking</th>
              <th>Score</th>
              <th>Name</th>
            </tr>
            <?php
                 $dbhost = "eu-cdbr-azure-west-b.cloudapp.net";
                 $dbuser = "bcf74a4a937449";
                 $dbpass = "fb35064177cf9e0";
                 $dbname = "arduinocoursework";
                 $db = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
                 if ($db -> connect_error){
                     die("Connection failed");
                 }
                 $query = "SELECT rank, score, name ";
                 $query .= "FROM scoreboard ";
                 $query .= "ORDER BY rank";
                 if (!$result = $db->query($query)){
                     die("Query failed");
                 }
                 while ($row = $result->fetch_assoc()){
                     echo "<tr>";
                     echo "<td>" . $row["rank"] . "</td>";
                     echo "<td>" . $row["score"] . "</td>";
                     echo "<td>" . $row["name"] . "</td>";
                     echo "</tr>";
                 }
                 $result->free();
                 $db -> close();
            ?>
        </table>
    </body>
</html>
