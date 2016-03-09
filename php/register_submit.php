<?php

include("common.php");
 
$userName = $_POST["userName"];
$userPass = $_POST["userPass"];
$useEmail = $_POST["useEmail"];
$userOccupation = $_POST["userOccupation"];
$randId = time()."".rand(99,20);

$message_reg = "";
if ($userName == "")
	$message_reg = "User Name cannot be empty<br>";
if ($userPass == "")
	$message_reg .= "User Password cannot be empty<br>";
if ($useEmail == "")
	$message_reg .= "User Email cannot be empty<br>";
if ($userOccupation == "")
        $message_reg .= "User Occupation should be given<br>";
	
//check existing user
$_SESSION["message_reg"] = "";
$link = mysql_connect('mysql.comp.polyu.edu.hk', 'biomet', 'qwkdjmxn');
mysql_select_db("biomet");
	
$sqlCheck = "select * from biometLogin where userName ='$userName';";	
$result = mysql_query($sqlCheck, $link);
$num_rows = mysql_num_rows($result);
	
if ($num_rows > 0){
	$message_reg .= "The user name you have chosen already exists. Please choose another.<br>";	
	mysql_free_result($result);
	mysql_close($link);
}
	
if  ($message_reg != ""){
	$_SESSION["message_reg"] = $message_reg;
	Header( "Location: register.php" ); 	
	mysql_free_result($result);
	mysql_close($link);		
	exit();
}
else
{
	//all data is valid, inserting into database
	$sql = "insert into biometLogin (userName, userPass, userEmail, randId, userOccupation) values ('$userName', '$userPass', '$useEmail','$randId', '$userOccupation');";
	mysql_query($sql, $link);
	mysql_free_result($result);

	//select new registed data's account ID for activation purpose
	$sqlNewId ="select idbiometLogin,randId from biometLogin where userName = '$userName'   ;";
	$resultUser = mysql_query($sqlNewId, $link);
	$rowMax = mysql_result($resultUser, 0,idbiometLogin);
	$randId = mysql_result($resultUser, 0,randId);
		

	 $to = "csajaykr@comp.polyu.edu.hk";
	 $subject = "Account Registration For Watchlist Officer ";
	 $message = "Dear Administrator,\n\t";
	 $message .= "\n\t";
	 $message .= "Below is the new account application.\n\t";
	 $message .= "\n\t";
	 $message .= "User Name: ".$userName."\n\t";
	 $message .= "User Email: ".$useEmail."\n\t";
	 $message .= "\n\t";
	 $message .= "Please click below link to activate the New Watchlist Officer Account:\n\t";
	 $message .= "
	 http://biomet.comp.polyu.edu.hk/project/account_activate.php?idLogin=". $rowMax."&randId=".$randId;
	 $message .= "\n\t";
	 $message .= "Please click below link to deny the New Watchlist Officer Account Application:\n\t";
	 $message .= "
	 http://biomet.comp.polyu.edu.hk/project/account_deActivate.php?idLogin=". $rowMax."&randId=".$randId;
	 
	$from = "csajaykr@comp.polyu.edu.hk";
	 $headers = "From:" . $from;
	 mail($to,$subject,$message,$headers);
	
	mysql_free_result($resultUser);
	mysql_close($link);

	include("header.php");
?>
		
<tr>
   <td valign="top" class="bgColor">
    <table width="760" border="0" cellspacing="0" cellpadding="0">
     <tr>
       <td width="10" height="30" class="content">&nbsp;</td>
       <td width="740" height="30" class="heading">User Registration</td>
       <td width="10" height="30" class="content">&nbsp;</td>
     </tr>
	 <tr>
	   <td width="10" class="content">&nbsp;</td>
    <!--   <td width="740" height="30" class="content">You have registered successfully. Please return back to <a href="login.php">Login</a> page.</td>-->
	   <td width="740" height="30" class="content">Officers from our department would process your registration application. You will receive e-mail notification when your application has been approved. </td>
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
}
?>