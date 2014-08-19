<script type="text/javascript" src="supportingFunc.js?v=1.4"></script>

<?php
include("common.php");
include("header.php");
?>
	
<!--
  <tr> 
	<tr>
	<td colspan="2"  height="30" ><input type="button" value="Watchlist Inspection"  onclick="open_win_identification()"></td>
	</tr>
-->	
<tr> 
   <td valign="top"  class="bgColor">
    <table width="960" border="0" cellspacing="0" cellpadding="0">
	
	
	<tr>
	<td colspan="3"  height="30" bgcolor="#C82435" ></td>
	</tr>
	 
	
    <tr>
	 
       <td width="10" height="30" class="content">&nbsp;</td>
       <td width="700" height="30" class="heading">Details of Suspects Under Surveillance
<?php
	$message = (isset($_SESSION["message"]) ? $_SESSION["message"] : "");	
	$userName = ( isset( $_SESSION["userName"] ) ? $_SESSION["userName"] : "" );




if ($message == "Invalid Login!")
	{
		echo("<br><br>" . $message);

	}
?>

<?php 

if ( $userName != "" ){

?>


 </td>
       <td width="50" height="30" class="content"><input type="button" value="Watchlist Inspection"  onclick="open_win_identification()"></td>
	   <td width="50" height="30" class="content"><input type="button" value="Differentiate Name"  onclick="open_win_identification()"></td>
     </tr>
    </table>
    <form name="suspectDataForm" id="suspectDataForm" method="post" enctype="multipart/form-data"   action="suspectsData_submit.php" onSubmit="return Check_Suspect_Form(suspectDataForm);">
       <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">First Name </td>
           <td width="640" class="content"><input name="firstname" id="firstname" type="text" class="textfieldStyle1" maxlength="32" value=""></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Last Name </td>
           <td width="640" class="content"><input name="lastname" id="lastname" type="text" class="textfieldStyle1" maxlength="32" value=""></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Gender </td>
           <td width="640" class="content">
			<input name="gender" type="radio" value="M" >Male
			<input name="gender" type="radio" value="F" >Female
		   </td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Age</td>
           <td width="640" class="content"><input name="age" type="text" class="textfieldStyle1" maxlength="10" value="">(Only number is allowed, range from 01 to 120)</td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Face </td>
           <td width="640" class="content"> <input name="facePath" type="file" id="facePath" />(Only gif, jpg, jpeg, png, bmp, tiff are allowed)</td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Fingerprint </td>
           <td width="640" class="content"><input name="fingerPath" type="file" id="fingerPath" />(Only gif, jpg, jpeg, png, bmp, tiff are allowed)</td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Iris </td>
           <td width="640" class="content"><input name="irisPath" type="file" id="irisPath" />(Only gif, jpg, jpeg, png, bmp, tiff are allowed)</td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
         <tr>
           <td width="10" class="content">&nbsp;</td>
           <td width="100" valign="top" class="content">Eye </td>
           <td width="640" class="content"><input name="eyesPath" type="file" id="eyesPath" />(Only gif, jpg, jpeg, png, bmp, tiff are allowed)</td>
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
			<input name="Submit2" type="reset" class="buttonStyle" value="Reset" onclick="javascript:document.location.href='suspectsData.php?action=reset'"></td>
           <td width="10" class="content">&nbsp;</td>
         </tr>
       </table>
    </form>
   </td>
  </tr>
  
 
<?php
  }else{


Header( "Location: login.php" ); 

  }
?>	   
	  
<?php
	include("footer.php");
?>