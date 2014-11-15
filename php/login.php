<?php
include("common.php");
$_SESSION["userName"] = "";
include("header.php"); 

//align="left"
?>

<script>
function open_win() 
{
myWindow=window.open('register.php','_self','');
myWindow.focus();
}
</script>

  <tr>
   <td valign="top" class="bgColor">
    <table width="760" border="0"   cellspacing="0" cellpadding="0">
	
     <tr>
       <td width="10" height="30" class="content">&nbsp;</td>
       <td width="740" height="30" class="heading">Login
<?php
	$message = (isset($_COOKIE[ "message" ]) ? $_COOKIE[ "message" ] : '');
	if ($message != "")
	{
		echo("<br><br>" . $message);
	}
?>
	   </td>
       <td width="10" height="30" class="content">&nbsp;</td>
     </tr>
    </table>
    <form name="form1" method="post" action="login_submit.php">
       <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">User Name </td>
           <td width="640" class="content"><input name="userName" type="text" class="textfieldStyle1"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Password </td>
           <td width="640" class="content"><input name="password" type="password" class="textfieldStyle1"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
		<tr>
			<td width="10" class="content">&nbsp;</td>
			<td colspan="3" class="content"><a href="forgotPassword.php">Forgot your password?</td>
		 </tr>
         <tr>
           <td class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">&nbsp;</td>
           <td width="640" class="content">&nbsp;</td>
           <td class="content">&nbsp;</td>
         </tr>
         
		 <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">&nbsp;</td>
		   
           <td width="640" class="content">
			<input name="Submit" type="submit" class="buttonStyle" value="Submit">
			<input name="Submit2" type="reset" class="buttonStyle" value="Reset">
			<input type="button" value="Register" class="buttonStyle" onclick="open_win()">
			</td>
			
           <td width="10" class="content">&nbsp;</td>
         </tr>
       </table>
    </form>
   </td>
  </tr>
<?php
include("footer.php");
?>
