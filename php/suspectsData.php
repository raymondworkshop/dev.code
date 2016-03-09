<script type="text/javascript" src="supportingFunc.js?v=1.4"></script>
<!--<link href="default.css" rel="stylesheet" type="text/css" media="screen" /> -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<?php
include("common.php");
include("header.php");
?>

<style>
   /* Begin Navigation Bar Styling */
   #nav {
      width: 100%;
      float: left;
      margin: 0 0 1em 0;
      padding: 0;
      list-style: none;
      background-color: #f2f2f2;
      border-bottom: 1px solid #ccc;
      border-top: 1px solid #ccc; }
   #nav a {
      float: left; }
   #nav  a {
      display: block;
      padding: 8px 15px;
      text-decoration: none;
      font-weight: bold;
      color: #069;
      border-right: 1px solid #ccc; }
   #nav  a:hover {
      color: #c00;
      background-color: #fff; }
   /* End navigation bar styling. */
   
</style>
</head>

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
	 	 

<!--<div id="wrap">
   
   <!-- Here's all it takes to make this navigation bar. -->
    <tr>
        <th>
        <ul id="nav">
	<a href="suspectsData.php">Home</a>
        <a href="watchListInspect.php">WatchList Inspection</a>
        <!--<a href="http://biomet.comp.polyu.edu.hk/project/spoofing.php">Spoofing and Disguise</a>
         -->
		</ul>
        </th>
     <tr>   
   <!-- That's it! -->
   
   <!--<div id="content"> -->
      <!--
      <p>It doesn't get much simpler than the navigation bar above. For more information on how this works, please <a href="http://www.cssnewbie.com/super-simple-horizontal-navigation-bar/">see the original CSS Newbie article.</a> For the code, just view the source.</p>
      -->
       <!--<table width='960' border='1' align='center' cellpadding='0' cellspacing='0' class='bgColor' >
       -->
       
       <!--<td width="10" height="30" class="content">&nbsp;</td>-->
       <tr> 
       <td width="700" height="30" class="heading">&nbsp;&nbsp;&nbsp;&nbsp;Details of Suspects Under Surveillance
       
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
     <!--
       <td width="50" height="30" class="content"><input type="button" value="Watchlist Inspection"  onclick="open_win_identification()"></td>
      -->
      </tr>
      <!-- </tr>-->
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
           <td width="100" valign="top" class="content">ID</td>
           <td width="640" class="content"><input name="id" type="text" class="textfieldStyle1" maxlength="10" value="">(Only number and character is allowed)</td>
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


</html>