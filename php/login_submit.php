<?php

include("common.php");

$userName = $_POST["userName"];
$password = $_POST["password"];
$link = mysql_connect('mysql.comp.polyu.edu.hk', 'biomet', 'qwkdjmxn');

if (!$link) {
			die('Could not connect: ' . mysql_error());
		}

mysql_select_db("biomet");
$sql = "select * from biometLogin where userName = '$userName' and userPass = '$password' and activate = True";
$result = mysql_query($sql, $link);
$num_rows = mysql_num_rows($result);
	
if ($num_rows == 0)
{
	setcookie("message","Invalid Login!",time()+3600);
	// header() is used to send a raw HTTP header 
	Header( "Location: login.php" ); 
}
else
{
	setcookie("message","",time()+3600);
	$_SESSION["userName"] = $userName;
	$line = mysql_fetch_array($result, MYSQL_ASSOC);
	$_SESSION["userName"] = $line["userName"];
	// is police officer or border officer
	$occupation_sql  = "select userOccupation from biometLogin where userName = '$userName' and userPass = '$password' and activate = True ";
    $result = mysql_query($occupation_sql, $link);
	
	while ($row = mysql_fetch_assoc($result)) {
	    // echo "$row['userOccupation']";
	if($row['userOccupation']){
	 //passport officer
	     Header( "Location: spoofing.php" );
	} else {
	 //police officer
	     Header( "Location: suspectsData.php" );
	}
	}
	
}
mysql_free_result($result);
?>