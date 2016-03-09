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
       <td width="740" height="30" class="heading">Password Request</td>
       <td width="10" height="30" class="content">&nbsp;</td>
     </tr>
	 </table>
	 
	  
  <form name="request_form" method="post" action="forgotPassword_submit.php">
       <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">User Name</td>
           <td width="640" class="content"><input name="userName" type="text" class="textfieldStyle1" maxlength="32" value=""></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
       
	<!--	 
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Email </td>
           <td width="640" class="content"><input id="useEmail" name="useEmail" type="text" class="textfieldStyle1" maxlength="96" value="" onblur="return validateEmail();">(e.g mysite123@ourearth.com)</td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
-->
       
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">&nbsp;</td>
           <td width="640" class="content">
			<input name="Submit" type="submit" class="buttonStyle" value="Submit"  onclick="return check_requestpw_form(request_form);">
			<input name="Submit2" type="reset" class="buttonStyle" value="Reset" onclick="javascript:document.location.href='forgotPasswored.php?action=reset'"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
		 
       </table>
	   
		
    </form> 
   </td>
  </tr>
<?php

?>	   
	  
<?php
	include("footer.php");
?>