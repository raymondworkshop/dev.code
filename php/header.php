<html>
<head> 
<title>Department of Computing, The Hong Kong Polytechnic University</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--Fireworks 8 Dreamweaver 8 target.  Created Sun Apr 23 20:14:40 GMT+0800 2006-->
<script language="JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

//-->
</script>
<link href="styles.css" rel="stylesheet" type="text/css">


</head>
<body>
<table width="780" align="center" border="0" cellpadding="0" cellspacing="0">
<!--<table width="780" height="100%" border="0" cellpadding="0" cellspacing="0">-->
<!-- fwtable fwsrc="source.png" fwbase="main.jpg" fwstyle="Dreamweaver" fwdocid = "77955695" fwnested="1" -->
  <tr>
   <td width="10" rowspan="2" valign="top">&nbsp;</td>
   <td height="76" valign="top">
	<table align="left" border="0" cellpadding="0" cellspacing="0" width="760">
	  <tr>
	   <td  ><img src="images/IRS_logo.png"  width="963" height="75"></td>
	   
	  </tr>
	  </tr><td align="right">
	     <?php

$userName = ( isset( $_SESSION["userName"] ) ? $_SESSION["userName"] : "" );

if ( $userName != "" )
{
echo "Welcome back " . $userName . "! &nbsp; <a href='logout.php'>Logout</a>";
}
?>
	  </td></tr>
	</table></td>
<!--	
   <td width="10" rowspan="2" valign="top">&nbsp;</td>
   -->
  </tr>