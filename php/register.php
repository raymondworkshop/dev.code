<?php
 //<script type="text/javascript" src="supportingFunc.js"></script>
include("common.php");

$_SESSION["firstname"] = "";
include("header.php");

?>
<script type="text/javascript" src="supportingFunc.js?v=1.3"></script>


  <tr> 
   <td valign="top" class="bgColor">
    <table width="760" border="0" cellspacing="0" cellpadding="0">
     <tr>
       <td width="10" height="30" class="content">&nbsp;</td>
       <td width="740" height="30" class="heading">User Registration</td>
       <td width="10" height="30" class="content">&nbsp;</td>
     </tr>
	 </table>
	 
	  
    <form name="form1" method="post" action="register_submit.php">
       <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">User Name</td>
           <td width="640" class="content"><input name="userName" type="text" class="textfieldStyle1" maxlength="32" value=""></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">User Password</td>
           <td width="640" class="content"><input id="userPass" name="userPass" type="password" class="textfieldStyle1" maxlength="32" value="" onblur="return validatePassword();" >(At least 8 characters including one digit and one letter)</td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
		 <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Re-enter Password</td>
           <td width="640" class="content"><input name="reEnterPass" type="password" class="textfieldStyle1" maxlength="32" value=""></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         
	 <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Occupation</td>
           <td width="640" class="content">
			<input name="userOccupation" type="radio" value="0" >Police Officer
			<input name="userOccupation" type="radio" value="1" >Border Officer
		   </td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
	 
	 <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Email </td>
           <td width="640" class="content"><input id="useEmail" name="useEmail" type="text" class="textfieldStyle1" maxlength="96" value="" onblur="return validateEmail();">(e.g mysite123@ourearth.com)</td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
    
	 </table>
	 
	 <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
		     <td width="10" class="content">&nbsp;</td>
		 </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">&nbsp;</td>
           <td width="640" class="content">
			<input name="Submit" type="submit" class="buttonStyle" value="Submit"  onclick="return Check_Form(form1);">
			<input name="Submit2" type="reset" class="buttonStyle" value="Reset" onclick="javascript:document.location.href='register.php?action=reset'"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
		 
       </table>
	   
		<table width="760" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		   <td width="10" height="30" class="content">&nbsp;</td>
		   <td width="740"  height="30" class="content" >
			 <?php
				$message_reg = (isset($_SESSION["message_reg"]) ? $_SESSION["message_reg"] : "");	
				$firstname = ( isset( $_SESSION["firstname"] ) ? $_SESSION["firstname"] : "" );
				if ($message_reg != "")
				{
					echo("<font color='red'>" . $message_reg."</font>");
					$_SESSION["message_reg"] = "";
				}
			?>
		 </td>
		 <td width="10" height="30" class="content">&nbsp;</td>
		 </tr>
         <!--
		 <tr><td width="760" height="30" class="content">&nbsp;</td></tr>
		 -->
		 </table>
    </form>
   </td>
  </tr>
<?php

?>	   
	  
<?php
	include("footer.php");
?>