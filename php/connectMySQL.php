<?php

//connect to the database
$link = mysql_connect('mysql.comp.polyu.edu.hk:3306', 'biomet', 'qwkdjmxn') 
        or die('Unable to connect: ' . mysql_error());
echo "Connected to MySQL \n";

//select a database to work with
if(!mysql_select_db('biomet', $link)){
    echo 'Could not select database';
    exit;
}

//Assume logo.jpg from the camera matches some picture, for example 140679558033-280Koala.jpg
//1) fetch the related information of 140679558033-280Koala.jpg from table biometData
//   -- idbiometData
 $sql = "select idbiometData from biometData where facePath='suspectsUpload/face/140679558033-280Koala.jpg';";
 $id_biomet =  mysql_result(mysql_query($sql, $link), 0) or die (mysql_error());
 echo "[DEBUG]id_biomet: $id_biomet \n";

//2) insert the information of the picture into table fingerMatchResulted
   $sql_max_id = "select MAX(idfaceMatchResulted) from faceMatchResulted";
   //$result = mysql_query($sql, $link);
   $max_match_id = mysql_result(mysql_query($sql_max_id, $link), 0) or die (mysql_error());
   echo "[DEBUG]max_match_id: $max_match_id \n";
   
   $insert_match_id = $max_match_id + 1;
   echo "[DEBUG]insert_match_id: $insert_match_id \n";
   $sql_matched = "insert into faceMatchResulted (idfaceMatchResulted,idbiometData, matchedScored,matchedPath, matchedRemark) values ($insert_match_id,$id_biomet, 0.60, 'suspectsUpload/matched/logo.jpg', 'the face match');";
   $result_matched = mysql_query($sql_matched, $link) or die (mysql_error());
   echo "[DEBUG] Insert a row to faceMatchResulted \n";
   //-- upload the file to the server

//2)
//execute the SQL query and return records
$sql = "select idbiometData, facePath,userName, clientIp from biomet.biometData where userName = 'wenlzhao';";

$result = mysql_query($sql, $link);

if(!$result) {
    echo "DB Error, could not query the database\n";
    echo 'MySQL Error:'. mysql_errot();
    exit;
} else {
   //fetch the data
   while($row = mysql_fetch_array($result)){
     echo "idbiometData:".$row{'idbiometData'}." facePath:".$row{'facePath'}." clientIp:".$row    {'clientIp'}."\n";
  }
}
//close the connection
mysql_close($link);

?>
