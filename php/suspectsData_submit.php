<?php
include("common.php");
include("header.php");
#$id  = 0;

 function imageDataPath($path,$type,$first_name, $last_name)
{
	$allowedExts = array("gif", "jpeg", "jpg", "png","pjpeg","x-png","bmp","tiff");
	$temp = explode(".", $_FILES[$path]["name"]);
	$extension = end($temp);
	//echo "type: " . $_FILES[$path]["type"] . "\n";
 if ((($_FILES[$path]["type"] == "image/gif")
 || ($_FILES[$path]["type"] == "image/jpeg")
 || ($_FILES[$path]["type"] == "image/jpg")
 || ($_FILES[$path]["type"] == "image/pjpeg")
 || ($_FILES[$path]["type"] == "image/x-png")
 || ($_FILES[$path]["type"] == "image/pjpeg")
 || ($_FILES[$path]["type"] == "image/bmp")
 || ($_FILES[$path]["type"] == "image/tiff"))
 && in_array($extension, $allowedExts))
   {
    if ($_FILES[$path]["error"] > 0)
      {
      echo "Error: " . $_FILES[$path]["error"] . "<br>";
      }
    else
      {
		//$location="suspectsUpload/".$type."/".$id_num."/";	
        $location="suspectsUpload/".$type."/";		
		//$id = time()."".rand(99,20);
		$imagePath = str_replace("'","''",$first_name."-".$last_name."_".rand(900,100)."-".$_FILES[$path]['name']);
		$imagePath = str_replace("#","_",$imagePath);
		
		//makedir($location);

		copy($_FILES[$path]['tmp_name'],$location.$imagePath);
		$imagePath=$location.$imagePath;
		
		//makedir($location);
     }
   }
 else
   {
     echo "wenlong";
 //  echo "Invalid file";
   }

return $imagePath;
}

function colValue($str){
	 #FirstName: ray; LastName: zhao; Gender: M; Age: 2
	 $string = " ";
	 #echo "<td class='content'>";
	 for($i=0; $i<count($str); $i++){
	     #echo "$str[$i]\n";
		 $field = explode(":", $str[$i]);
		 
		 #echo "$field[0]=> $field[1]\n";
		$string = $string . "$field[0]:" . "<font color='red'>$field[1]</font>";
     } 
	 
	 return $string;
}	

function makedir($dir){
    if(file_exists($dir) && is_dir($dir)){
	     echo "dir $dir exists \n";
    
	}else {
	     echo "dir $dir not exists \n";
	     echo "[DEBUG]:mkdir $dir \n";
		 #mkdir the dir	
		 #NOTICE: realpath function only work if the dir exists
         #$local = realpath("$windows_dir"); 
	     mkdir($dir, 0777);		 
   }
}

/*
	$message = (isset($_SESSION["message"]) ? $_SESSION["message"] : "");	
		if ($message != ""){
			echo("<br><br>" . $message);
		}
*/
$firstname = $_POST["firstname"];
$lastname = $_POST["lastname"];
$gender = $_POST["gender"];
$age = $_POST["age"];
$idnum = $_POST["id"];
$facePath=$_POST["facePath"];
$fingerPath=$_POST["fingerPath"];

$message = "";

if(!((strlen($_FILES["facePath"]["name"])>0)
   ||(strlen($_FILES["fingerPath"]["name"])>0)
   ||(strlen($_FILES["irisPath"]["name"])>0)
   ||(strlen($_FILES["eyesPath"]["name"])>0)
   )){
   $message = "At least one image need to be uploaded<br>";
   }

if ($firstname == "")
	$message .= "firstname cannot be empty<br>";
if ($gender == "")
	$message .= "Gender cannot be empty<br>";
if ($lastname == "")
	$message .= "lastname cannot be empty<br>";
	
if  ($message != "")
{
	$_SESSION["message"] = $message;
	
	Header( "Location: suspectsData.php" ); 
	exit();
}
else
{
	//echo "type: " . $_FILES["facePath"]["type"] . "\n";
	//echo "name: " . $_FILES["facePath"]["name"] . "\n";
	//echo "tmp_name: " . $_FILES["facePath"]["tmp_name"] . "\n";
	if(strlen($_FILES["facePath"]["name"])>0)
	{
	$facePath=imageDataPath("facePath","face",$firstname, $lastname);
	//echo "facePath:$facePath\n";
	}
	
	if(strlen($_FILES["fingerPath"]["name"])>0)
	{
	$fingerPath=imageDataPath("fingerPath","finger",$firstname, $lastname);
	}
	
	if(strlen($_FILES["irisPath"]["name"])>0)
	{
	$irisPath=imageDataPath("irisPath","iris",$firstname, $lastname);
	}

	if(strlen($_FILES["eyesPath"]["name"])>0)
	{
	$eyesPath=imageDataPath("eyesPath","eyes",$firstname, $lastname);
	}

	$clientIP=$_SERVER['REMOTE_ADDR'];

   //$userName
   ##For the replicated name
   #for database connection
	//connect to the database
    $link = mysql_connect('mysql.hk:3306', 'biomet', 'qwkdjmxn') 
        or die('Unable to connect: ' . mysql_error());
    #echo "Connected to MySQL \n";

    //select a database to work with
    if(!mysql_select_db('biomet', $link)){
          echo 'Could not select database';
         exit;
     }
     // echo "$firstname $lastname\n"; //input name not the login name
     // $query_sql = "select firstName,lastName from biometData where firstName = '$firstname' and lastName= '$lastname';";
     // $query_result = mysql_query($query_sql, $link)
                // or die ('MySQL Error: ' . mysql_error());
	
	 // while($row = mysql_fetch_assoc($query_result)){
	     // $first_name = $row['firstName'];
		 // $last_name = $row['lastName'];
     // }	 
	// mysql_free_result($query_result);
	
    // if(strlen($first_name)>0 and strlen($last_name)>0) {
	    // #echo "Replication Suspects Name";
	 // #if name replication
	  		 // echo "</table>"; 
		     // echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0'>";
		     // echo "<tr><td class='content'><font color='red'>Suspect Name Replication. Please choose the Candidates</font></td></tr>";
		     // #echo "<tr><td  height='30' bgcolor='#C82435' class='content' ></td></tr>";
		     // #echo "</table>";
	     
		     // #echo "</table>"; 
		     // #echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0'>";
		     // echo "<tr><td class='content'>Return to <a href='suspectsData.php'>Update Suspects Data</a> page.</td></tr>";
		     // #echo "<tr><td  height='30' bgcolor='#C82435' class='content' ></td></tr>";
		     // echo "</table>";
	
	         // echo "<table width='960' border='1' align='center' cellpadding='0' cellspacing='0' class='bgColor' >";
		     // echo "<tr>";
		     // echo "<th class='heading'>Choice</th>";
			 // echo "<th class='heading'></th>";
		     // echo "<th class='heading' style='color:blue;'>Replicated Suspects</th>";
		     
		     // #echo "<th class='heading'>Replicated Subject</th>";
		     // echo "<th class='heading'>Details</th>";
		     // echo "</tr>";
		
         // $query_sql = "select idbiometData, firstName,lastName,eyesPath,facePath,fingerPath,irisPath,clientIp,gender, Age from biometData where firstName = '$firstname' and lastName= '$lastname';";
         // $query_result = mysql_query($query_sql, $link)
                // or die ('MySQL Error: ' . mysql_error());		
        // while($row = mysql_fetch_assoc($query_result)){				

	         // #$eyes_path = $row['eyesPath'];
	         // #echo "Name: $first_name  $last_name \n";
    
	         // echo "<tr><td colspan='4' class='content'><p align=\"left\">Suspects Name:<b>". $row['lastName'] ." ".$row['firstName']." Uploader Ip(".$row['clientIp'].")</b></a></p></td></tr>";
			   
			// if(strlen($row['eyesPath'])>0){
			    // $id = $row['idbiometData'];
			    // echo "<tr>";
			    // #echo "<td><form action='suspectsChoice_submit.php' method = 'post'>
				// echo "<td> <form action='suspectsChoice_submit.php' method = 'post'><rowspan='2'> 
				// <input type = 'radio' name='choice' value='Yes' />Yes
                // <input type = 'radio' name='choice' value='No' checked />No
				
                // <input type='submit' name='submit' value='Submit' /> 				
				// </form></td>";
				
				// echo "<td class='content'><b><div align=center>Eye : </div></b></td>";
				// echo "<td><div align=center><img src=\"". $row['eyesPath']."\" width=\"200\" ></div></td>" ;		
				// #$arr = explode(";", $row['eyesMatchedRemark']);
				// # $details = colValue($arr);
				 // $separate = "; ";
				 // $first_name =  $row['firstName'];
	             // $last_name =  $row['lastName'];
				 // $name = "FirstName:" . $first_name . $separate ."LastName: " . $last_name ;
				 // $age = $row['Age'];
				 // $gender = $row['gender'];
				 // $other = $name . $separate .  "Age:" . $age . $separate ."Gender: " . $gender ;
				 // $arr = explode(";", $other);
				 // #$detail = $name . $separate . $other;
				 // #$details = "no data";
				 
				 	            // #for($i=0; $i<count($arr); $i++){
	            // #echo "$arr[$i]\n";
		        // #     $field = explode(":", $arr[$i]);
		 
		             // #echo "$field[0]=> $field[1]\n";
				// #	 $details = $details . "$field[0]:" . "<font color='red'>$field[1]</font>";
                // # }
				 
				 // $details = colValue($arr);
				 // echo "<td class='content'><div align=center>".$details."</div></td></tr>";			   
			// }
		
		
		// # echo "</table>";
		// #echo "<br>";
		// #echo "<table width='780' border='0' align='center' cellpadding='0' cellspacing='0'>";
		// #echo "</table>";	
		// #echo "<br>";		

        // }
		
		// mysql_free_result($query_result);
	// }
  //else {

	    #$link = mysql_connect('mysql.comp.polyu.edu.hk', 'biomet', 'qwkdjmxn');
	    #mysql_select_db("biomet");
	    $sql = "insert into biometData (firstname, lastname, gender, Age, facePath, fingerPath, irisPath, eyesPath,userName,clientIp, id) values ('$firstname', '$lastname', '$gender', '$age', '$facePath', '$fingerPath', '$irisPath', '$eyesPath','$userName','$clientIP', '$idnum');";
	    $result = mysql_query($sql, $link);

	    if (!$result) {
		     echo "DB Error, could not query the database\n";
		     echo 'MySQL Error: ' . mysql_error();
		     exit;
	     }

	     mysql_free_result($result);
	
	    if(strlen($facePath)>0){
		     $sqlMaxId = " select idbiometData from biometData where facePath = '$facePath' and userName = '$userName';";
		     $resultData = mysql_query($sqlMaxId,$link);
		     $rt_idbiometData = mysql_result($resultData, 0,idbiometData);
		     mysql_free_result($resultData);
		     $sqlMatched = "insert into faceMatchResulted (idbiometData, matchedRemark) values ('$rt_idbiometData', 'no data yet');";
		     $resultMatched = mysql_query($sqlMatched, $link);
		    if (!$resultMatched) {
			echo "DB Error, could not query the database\n";
			echo 'MySQL Error: ' . mysql_error();
			exit;
		    }
		    mysql_free_result($resultMatched);
	    }
	
		if(strlen($fingerPath)>0){
		    $sqlMaxId = " select idbiometData from biometData where fingerPath = '$fingerPath' and userName = '$userName';";
		$resultData = mysql_query($sqlMaxId,$link);
		$rt_idbiometData = mysql_result($resultData, 0,idbiometData);
		mysql_free_result($resultData);
		$sqlMatched = "insert into fingerMatchResulted (idbiometData, matchedRemark) values ('$rt_idbiometData', 'no data yet');";
		$resultMatched = mysql_query($sqlMatched, $link);
		if (!$resultMatched) {
			echo "DB Error, could not query the database\n";
			echo 'MySQL Error: ' . mysql_error();
			exit;
		}
		mysql_free_result($resultMatched);
		}
	
		if(strlen($irisPath)>0){
		$sqlMaxId = " select idbiometData from biometData where irisPath = '$irisPath' and userName = '$userName';";
		$resultData = mysql_query($sqlMaxId,$link);
		$rt_idbiometData = mysql_result($resultData, 0,idbiometData);
		mysql_free_result($resultData);
		$sqlMatched = "insert into irisMatchResulted (idbiometData, matchedRemark) values ('$rt_idbiometData', 'no data yet');";
		$resultMatched = mysql_query($sqlMatched, $link);
		if (!$resultMatched) {
			echo "DB Error, could not query the database\n";
			echo 'MySQL Error: ' . mysql_error();
			exit;
		}
		mysql_free_result($resultMatched);
		}
	
		if(strlen($eyesPath)>0){
		$sqlMaxId = " select idbiometData from biometData where eyesPath = '$eyesPath' and userName = '$userName';";
		$resultData = mysql_query($sqlMaxId,$link);
		$rt_idbiometData = mysql_result($resultData, 0,idbiometData);
		mysql_free_result($resultData);
		$sqlMatched = "insert into eyesMatchResulted (idbiometData, matchedRemark) values ('$rt_idbiometData', 'no data yet');";
		$resultMatched = mysql_query($sqlMatched, $link);
		if (!$resultMatched) {
			echo "DB Error, could not query the database\n";
			echo 'MySQL Error: ' . mysql_error();
			exit;
		}
		mysql_free_result($resultMatched);
		}
	
	 	     echo "</table>"; 
		     echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0'>";
			 echo "<tr><td class='content'><font color='red'>Suspects Data Updated</font></td></tr>";
		     #echo "<tr><td  height='30' bgcolor='#C82435' class='content' ></td></tr>";
		     #echo "</table>";
	     
		     #echo "</table>"; 
		     #echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0'>";
		     echo "<tr><td class='content'>Return to <a href='suspectsData.php'>Update Suspects Data</a> page.</td></tr>";
		     #echo "<tr><td  height='30' bgcolor='#C82435' class='content' ></td></tr>";
	         echo "</table>";
	//}
}
?>

<?php
#include("footer.php");
?>