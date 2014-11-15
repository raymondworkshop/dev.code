<?php
  include("common.php");
  
  $action = ( isset( $_GET[ "action" ] ) ? $_GET[ "action" ] : "" );

  if ( $action == "send" )
  {
	  $name = ( isset( $_POST[ "name" ] ) ? $_POST[ "name" ] : "" );
	  $mobile = ( isset( $_POST[ "mobile" ] ) ? $_POST[ "mobile" ] : "" );
	  $email = ( isset( $_POST[ "email" ] ) ? $_POST[ "email" ] : "" );
	  $description = ( isset( $_POST[ "description" ] ) ? $_POST[ "description" ] : "" );
	  	
	  $toemail = "youremail";
	  $subject = "Enquiry by - " . $name;
      $message = "Mobile = $mobile \n Email = $email \n Description = $description \n";
	
	  //使用 php mail 功能傳送電子郵件
	  if ( mail( $toemail, $subject, $message ) )
	  {
?>
		<script type="text/javascript">	
			alert('Your enquiry has been sent!');
		</script>
<?php
		  
	  }
	  else
	  {
?>
		<script type="text/javascript">
			alert('Your enquiry has been sent!');
		</script>
<?php
	  }
  }
  
  include("header.php");
?>
  <tr>
   <td valign="top" class="bgColor">
     <table width="760" border="0" cellspacing="0" cellpadding="0">
       <tr>
         <td width="10" height="30" class="content">&nbsp;</td>
         <td width="740" height="30" class="heading">Enquiry Form</td>
         <td width="10" height="30" class="content">&nbsp;</td>
       </tr>
     </table>
     <form name="frm" method="post" action="contactus.php?action=send">
       <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Name </td>
           <td width="640" class="content"><input name="name" type="text" class="textfieldStyle1"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Mobile </td>
           <td width="640" class="content"><input name="mobile" type="text" class="textfieldStyle1"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Email </td>
           <td width="640" class="content"><input name="email" type="text" class="textfieldStyle1"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Description </td>
           <td width="640" class="content"><textarea name="description" rows="4" class="textfieldStyle1"></textarea></td>
           <td width="10" class="content">&nbsp;</td>
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
			<input name="Submit2" type="reset" class="buttonStyle" value="Reset" onClick="contactus.php"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
       </table>
      </form></td>
  </tr>
<?php
	include("footer.php");
?>