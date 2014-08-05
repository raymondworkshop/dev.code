<?php
include("common.php");
include("header.php");

 function imageDataPath($path,$type)
{
	$allowedExts = array("gif", "jpeg", "jpg", "png","pjpeg","x-png","bmp","tiff");
	$temp = explode(".", $_FILES[$path]["name"]);
	$extension = end($temp);
	
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
		$location="suspectsUpload/".$type."/";		
		//$id = time()."".rand(99,20);
		$imagePath = str_replace("'","''",$_FILES[$path]['name']);
		$imagePath = str_replace("#","_",$imagePath);

		copy($_FILES[$path]['tmp_name'],$location.$imagePath);
		$imagePath=$location.$imagePath;
     }
   }
 else
   {
 //  echo "Invalid file";
   }

return $imagePath;
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
	
	if(strlen($_FILES["facePath"]["name"])>0)
	{
	$facePath=imageDataPath("facePath","face");
	}
	
	if(strlen($_FILES["fingerPath"]["name"])>0)
	{
	$fingerPath=imageDataPath("fingerPath","finger");
	}
	
	if(strlen($_FILES["irisPath"]["name"])>0)
	{
	$irisPath=imageDataPath("irisPath","iris");
	}

	if(strlen($_FILES["eyesPath"]["name"])>0)
	{
	$eyesPath=imageDataPath("eyesPath","eyes");
	}

	$clientIP=$_SERVER['REMOTE_ADDR'];

//$userName
	$link = mysql_connect('mysql.comp.polyu.edu.hk', 'biomet', 'qwkdjmxn');
	mysql_select_db("biomet");
	$sql = "insert into biometData (firstname, lastname, gender, Age, facePath, fingerPath, irisPath, eyesPath,userName,clientIp) values ('$firstname', '$lastname', '$gender', '$age', '$facePath', '$fingerPath', '$irisPath', '$eyesPath','$userName','$clientIP');";
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
	
	
	
	
	
	
}

?>
<tr>
   <td valign="top" class="bgColor">
    <table width="760" border="0" cellspacing="0" cellpadding="0">
     <tr>
       <td width="10" height="30" class="content">&nbsp;</td>
       <td width="740" height="30" class="heading">Suspects Data Updated!</td>
       <td width="10" height="30" class="content">&nbsp;</td>
     </tr>
	 <tr>
	   <td width="10" class="content">&nbsp;</td>
       <td width="740" height="30" class="content">One suspects data was updated. Please return back to <a href="suspectsData.php">Update Suspects Data</a> page.</td>
	   <td width="10" class="content">&nbsp;</td>
	 </tr>
	 <tr>
	   <td class="content">&nbsp;</td>
	   <td width="740" height="30" class="heading">&nbsp;</td>
	   <td class="content">&nbsp;</td>
	 </tr>
    </table>
   </td>
  </tr>
<?php
include("footer.php");
?>