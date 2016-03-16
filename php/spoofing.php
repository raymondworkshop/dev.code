<script type="text/javascript" src="supportingFunc.js?v=1.4"></script>

<?php
include("common.php");
include("header.php");
?>

<head>
    <meta http-equiv="refresh" content="5"; url="http://biomet.hk/project/spoofing.php">
</head>	

<?php
	$message = (isset($_SESSION["message"]) ? $_SESSION["message"] : "");	
	$userName = ( isset( $_SESSION["userName"] ) ? $_SESSION["userName"] : "" );
if ($message == "Invalid Login!")
	{
		echo("<br><br>" . $message);
	}
?>
  </td>
  </tr>

<?php		
function colValue($str){
	 #FirstName: ray; LastName: zhao; Gender: M; Age: 2
	 $string = " ";
	 #echo "<td class='content'>";
	 for($i=0; $i<count($str); $i++){
	     #echo "$str[$i]\n";
		 $field = explode(":", $str[$i]);
		 
		 #echo "$field[0]=> $field[1]\n";
		$string = $string . "$field[0]:" . "<font color='red'>$field[1]</font>";
     } 
	 
	 return $string;
}	
	
if ( $userName != "" ){
		$link = mysql_connect('mysql.comp.polyu.edu.hk','biomet', 'qwkdjmxn');
		if (!$link) {
			die('Could not connect: ' . mysql_error());
		}
		if (!mysql_select_db('biomet', $link)) {
			echo 'Could not select database';
			exit;
		}
		
		//if it is a mask, then update the related date into 
		
	//	$sql    = "select firstname,lastname,facePath,fingerPath,irisPath,eyesPath FROM biometData where userName = '$userName'   ;";
		
		//$sql_mask = "select matchedScored, matchedPath, matchedRemark from faceMatchResulted where ismaskMatch = 1 and currentMatch = 0 and TIMESTAMPDIFF(MINUTE, time, now()) <= 20;";
		$sql_mask = "select matchedScored, matchedPath, matchedRemark from faceMatchResulted where ismaskMatch = 1 and currentMatch = 0 ";
		
		$result_mask = mysql_query($sql_mask, $link);
		
		if (!$result_mask) {
			  echo "DB Error, could not query the database\n";
			  echo 'MySQL Error: ' . mysql_error();
			  exit;
		 }
		
		//only display the matched ones in 5m
		//$sql    = "select clientIp,main.idbiometData,firstname,lastname,facePath,fingerPath,irisPath,eyesPath,
		//			face.matchedScored as faceScored,face.matchedPath as faceMatchedPath,face.matchedRemark as faceMatchedRemark,
		//			iris.matchedScored as irisScored,iris.matchedPath as irisMatchedPath,iris.matchedRemark as irisMatchedRemark,
		//			eyes.matchedScored as eyesScored,eyes.matchedPath as eyesMatchedPath,eyes.matchedRemark as eyesMatchedRemark,
		//			finger.matchedScored as fingerScored,finger.matchedPath as fingerMatchedPath,finger.matchedRemark as fingerMatchedRemark
		//			from biomet.biometData main left outer join biomet.eyesMatchResulted eyes on main.idbiometData =eyes.idbiometData 
		//			left outer  join biomet.faceMatchResulted face on main.idbiometData = face.idbiometData 
		//			 left outer  join biomet.irisMatchResulted iris on iris.idbiometData = main.idbiometData 
		//			left outer  join biomet.fingerMatchResulted finger on finger.idbiometData = main.idbiometData
		//			WHERE TIMESTAMPDIFF(MINUTE, time, now()) <= 10 and ismaskMatch = 1 and currentMatch = 1;";
		
		$sql    = "select clientIp,main.idbiometData,firstname,lastname,facePath,fingerPath,irisPath,eyesPath,
					face.matchedScored as faceScored,face.matchedPath as faceMatchedPath,face.matchedRemark as faceMatchedRemark,
					iris.matchedScored as irisScored,iris.matchedPath as irisMatchedPath,iris.matchedRemark as irisMatchedRemark,
					eyes.matchedScored as eyesScored,eyes.matchedPath as eyesMatchedPath,eyes.matchedRemark as eyesMatchedRemark,
					finger.matchedScored as fingerScored,finger.matchedPath as fingerMatchedPath,finger.matchedRemark as fingerMatchedRemark
					from biomet.biometData main left outer join biomet.eyesMatchResulted eyes on main.idbiometData =eyes.idbiometData 
					left outer  join biomet.faceMatchResulted face on main.idbiometData = face.idbiometData 
					 left outer  join biomet.irisMatchResulted iris on iris.idbiometData = main.idbiometData 
					left outer  join biomet.fingerMatchResulted finger on finger.idbiometData = main.idbiometData
					where ismaskMatch = 1 and currentMatch = 1;";
		
		
		$result = mysql_query($sql, $link);

		if (!$result) {
			echo "DB Error, could not query the database\n";
			echo 'MySQL Error: ' . mysql_error();
			exit;
		}

		echo "</table>"; 
		echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0'>";
		//echo "<tr><td class='content'>Return to <a href='suspectsData.php'>Home </a> page.</td></tr>";
		echo "<tr><td  height='30' bgcolor='#C82435' class='content' ></td></tr>";
		echo "</table>";
	//	echo "<br>";
		
		if (mysql_num_rows($result_mask)) {
		echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0' class='bgColor' >";
		//echo "<tr>";
		//echo "<th class='heading'></th>";
		//echo "<th class='heading' >The Suspects</th>";
		//echo "<th class='heading'>Score</th>";
		//echo "<th class='heading'>Matched Subject</th>";
		//echo "<th class='heading'>Details</th>";
		//echo "</tr>";
		
		//display the mask suspect
		while ($row = mysql_fetch_assoc($result_mask)) {	
		    if(strlen($row['matchedPath'])>0){
			    //echo "<tr><td class='content'><div align=center><b><font color='red'>The System: </font></b></div></td>";
				//echo "<td class='content'><div align=center><img src=\"". $row['faceMatchedPath']."\" width=\"200\" ></div></td>" ;
				
				//$arr = explode(";", $row['matchedRemark']);
				//$arr = $arr . "; Score:9"
				//$details = colValue($arr);
				
				//echo "<td class='content'>".$details."</td></tr>";
				//echo "<tr><td class='content'>&nbsp</td></tr>";
				
				echo "<tr><td class='content'><div align=center><b><font color='red'>Mask Detected: </font></b></div></td>";
				echo "<td class='content'><img src=\"". $row['matchedPath']."\" width=\"220\" ></td>" ;
				echo "<td class='content'><div align=center>&nbsp</div></td></tr>";
				
				echo "<tr><td class='content'>&nbsp</td></tr>";
				echo "<tr><td class='content'><div align=center><b><font color='red'>The Details:</font></b></div></td>";
				//echo "<td class='content'><div align=center><img src=\"". $row['faceMatchedPath']."\" width=\"200\" ></div></td>" ;
				$string = $row['matchedRemark'] . " Score" . ": " .  $row['matchedScored'];
				//echo "str:$string\n";
				$arr = explode(";", $string);
				//$arr = $arr . "; Score:9"
				$details = colValue($arr);
				
				echo "<td class='content'>".$details."</td></tr>";
				
			   }
		   }
		
		
		}
		
		if (mysql_num_rows($result)) {
		echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0' class='bgColor' >";
		//echo "<tr>";
		//echo "<th class='heading'></th>";
		//echo "<th class='heading' >Watchlist Suspects</th>";
		//echo "<th class='heading'>Matched Score</th>";
		//echo "<th class='heading'>Matched Subject</th>";
		//echo "<th class='heading'>Details</th>";
		//echo "</tr>";


		//display the matched suspect
		while ($row = mysql_fetch_assoc($result)) {			    
			//echo "<tr><td colspan='5' class='content'><p align=\"left\"><b><font color='#069'>Suspects Name: </font>". $row['lastname'] ." ".$row['firstname']."&nbsp;&nbsp; &nbsp;&nbsp;<font color='#069'> Watchlist Officer: </font>IP(".$row['clientIp'].")</b></a></p></td></tr>";
			
			if(strlen($row['facePath'])>0){
				echo "<tr><td class='content'><div align=center><b><font color='red'>Suspect Detected: </font></b></div></td>";
				echo "<td class='content'><img src=\"". $row['facePath']."\" width=\"220\" ></td>" ;
				echo "<td class='content'><img src=\"". $row['faceMatchedPath']."\" width=\"220\" ></td></tr>" ;
				
				echo "<tr><td class='content'>&nbsp</td></tr>";
				
				echo "<tr><td class='content'><div align=center><b><font color='red'>The Details:</font></b></div></td>";
				//echo "<td class='content'>".$row['faceScored']."</td>";
				$string = $row['faceMatchedRemark'] . " Score" . ": " .  $row['matchedScored'];
				$arr = explode(";", $string);
				$details = colValue($arr);
				
				echo "<td class='content'><div align=center>".$details."</div></td>";
				echo "<td class='content'><div align=center>&nbsp</div></td></tr>";
			   }
			  
			if(strlen($row['fingerPath'])>0){
			    echo "<tr><td class='content'><b>Fingerprint: </b></td>";
				echo "<td class='content'><div align=center><img src=\"". $row['fingerPath']."\" width=\"200\" ></div></td>" ;
				echo "<td class='content'><div align=center>".$row['fingerScored']."</div></td>";
			    echo "<td class='content'><div align=center><img src=\"". $row['fingerMatchedPath']."\" width=\"200\" ></div></td>" ;
				
				$arr = explode(";", $row['fingerMatchedRemark']);
				$details = colValue($arr);
				echo "<td class='content'><div align=center>".$details."</div></td></tr>";			  
			}
			   
			if(strlen($row['irisPath'])>0){
				 echo "<tr><td class='content'><b>Iris: </b></td>";
				echo "<td class='content'><div align=center><img src=\"". $row['irisPath']."\" width=\"200\" ></div></td>" ;
				echo "<td class='content'><div align=center>".$row['irisScored']."</div></td>";
				echo "<td><div align=center><img src=\"". $row['irisMatchedPath']."\" width=\"200\" ></div></td>" ;
				
				$arr = explode(";", $row['irisMatchedRemark']);
				$details = colValue($arr);
				echo "<td class='content'><div align=center>".$details."</div></td></tr>";			   
				
			}
			   
			if(strlen($row['eyesPath'])>0){
				echo "<tr><td class='content'><b>Eye: </b></td>";
				echo "<td class='content'><div align=center><img src=\"". $row['eyesPath']."\" width=\"200\" ></div></td>" ;
				echo "<td class='content'><div align=center> ".$row['eyesScored']." </div></td>";
			    echo "<td><div align=center><img src=\"". $row['eyesMatchedPath']."\" width=\"200\" ></div></td>" ;
				
				$arr = explode(";", $row['eyesMatchedRemark']);
				#$details = " ";
				#echo "<td class='content'>";
	            #for($i=0; $i<count($arr); $i++){
	            #echo "$arr[$i]\n";
		        #     $field = explode(":", $arr[$i]);
		 
		             #echo "$field[0]=> $field[1]\n";
				#	 $details = $details . "$field[0]:" . "<font color='red'>$field[1]</font>";
                # }
				 $details = colValue($arr);
				 
				 echo "<td class='content'><div align=center>".$details."</div></td></tr>";			   }
		}
		
		}
		echo "</table>";
		echo "<br>";
		echo "<table width='780' border='0' align='center' cellpadding='0' cellspacing='0'>";
		echo "</table>";	
		echo "<br>";
		mysql_free_result($result_mask);
		mysql_free_result($result);

  }else{
Header( "Location: login.php" );   }
?>	   
	  
