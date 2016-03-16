<?php
include("common.php");
 
$userName = $_POST["userName"];
//$userPass = $_POST["userPass"];
//$useEmail = $_POST["useEmail"];

$message_reg = "";
if ($userName == "")
	$message_reg = "User Name cannot be empty<br>";
//if ($useEmail == "")
//	$message_reg .= "User Email cannot be empty<br>";

//check existing user
$_SESSION["message_reg"] = "";
$link = mysql_connect('mysql.hk', 'biomet', 'qwkdjmxn');
mysql_select_db("biomet");
	
$sqlCheck = "select userName,userPass,userEmail from biometLogin where userName ='$userName';";	
$result = mysql_query($sqlCheck, $link);
$num_rows = mysql_num_rows($result);
	
if ($num_rows > 0){
	
	$rt_userName = mysql_result($result, 0,userName);
	$rt_userEmail = mysql_result($result, 0,userEmail);
	$rt_userPass = mysql_result($result, 0,userPass);
	
	
	$to = $rt_userEmail;
//	 $to = "csajaykr@comp.polyu.edu.hk";
//	$to = "lauohung@gmail.com";
	 $subject = "Watchlist Application - REQUEST PASSWORD";
	 $message = "Dear Watchlist Officer,\n\t";
	 $message .= "\n\t";
	 $message .= "As per your request, please refer to the details below: \n\t";
	 $message .= "\n\t";
	 $message .= "User Name: ".$rt_userName."\n\t";
	 $message .= "User Password: ".$rt_userPass."\n\t";
	 $message .= "\n\t";
	 $message .= "Please memorize it and delete this email to avoid unauthorized access.\n\t";
	 $message .= "\n\t";
	 $message .= "\n";
	 $message .= "Regards,\n";
	 $message .= "Administrator\n\t";


	 
	$from = "csajaykr@comp.polyu.edu.hk";
//	 $from = "lauohung@gmail.com";
	 $headers = "From:" . $from;
	 mail($to,$subject,$message,$headers);
	
$message="Officers from our department would process your registration application. You will receive your password through your registered e-mail.";
	
	mysql_free_result($result);
	mysql_close($link);
}else{

$message="The User Name [ ".$userName." ]does not exist!";

}




	include("header.php");
	?>
		
<tr>
   <td valign="top" class="bgColor">
    <table width="760" border="0" cellspacing="0" cellpadding="0">
     <tr>
       <td width="10" height="30" class="content">&nbsp;</td>
       <td width="740" height="30" class="heading">REQUEST PASSWORD</td>
       <td width="10" height="30" class="content">&nbsp;</td>
     </tr>
	 <tr>
	   <td width="10" class="content">&nbsp;</td>
	   <?php echo '<td width="740" height="30" class=\'content\'>'.$message.'</td>'?>

    <!--   <td width="740" height="30" class="content">You have registered successfully. Please return back to <a href="login.php">Login</a> page.</td>-->
	<!--   <td width="740" height="30" class="content">Officers from our department would process your registration application. You will receive your password through your registered e-mail. </td>-->
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
//}
?>