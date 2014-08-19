<script type="text/javascript" src="supportingFunc.js?v=1.4"></script>

<?php
include("common.php");
include("header.php");
?>
	
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
		
	//	$sql    = "select firstname,lastname,facePath,fingerPath,irisPath,eyesPath FROM biometData where userName = '$userName'   ;";
		
		$sql    = "select clientIp,main.idbiometData,firstname,lastname,facePath,fingerPath,irisPath,eyesPath,
					face.matchedScored as faceScored,face.matchedPath as faceMatchedPath,face.matchedRemark as faceMatchedRemark,
					iris.matchedScored as irisScored,iris.matchedPath as irisMatchedPath,iris.matchedRemark as irisMatchedRemark,
					eyes.matchedScored as eyesScored,eyes.matchedPath as eyesMatchedPath,eyes.matchedRemark as eyesMatchedRemark,
					finger.matchedScored as fingerScored,finger.matchedPath as fingerMatchedPath,finger.matchedRemark as fingerMatchedRemark
					from biomet.biometData main left outer join biomet.eyesMatchResulted eyes on main.idbiometData =eyes.idbiometData 
					left outer  join biomet.faceMatchResulted face on main.idbiometData = face.idbiometData 
					 left outer  join biomet.irisMatchResulted iris on iris.idbiometData = main.idbiometData 
					left outer  join biomet.fingerMatchResulted finger on finger.idbiometData = main.idbiometData
					where userName = '$userName' order by main.idbiometData asc   ;";
		
		
		$result = mysql_query($sql, $link);

		if (!$result) {
			echo "DB Error, could not query the database\n";
			echo 'MySQL Error: ' . mysql_error();
			exit;
		}

		echo "</table>"; 
		echo "<table width='960' border='0' align='center' cellpadding='0' cellspacing='0'>";
		echo "<tr><td class='content'>Return to <a href='suspectsData.php'>Update Suspects Data</a> page.</td></tr>";
		echo "<tr><td  height='30' bgcolor='#C82435' class='content' ></td></tr>";
		echo "</table>";
	//	echo "<br>";
		
		echo "<table width='960' border='1' align='center' cellpadding='0' cellspacing='0' class='bgColor' >";
		echo "<tr>";
		echo "<th class='heading'></th>";
		echo "<th class='heading' style='color:blue;'>Uploaded Suspects</th>";
		echo "<th class='heading'>Matched Score</th>";
		echo "<th class='heading'>Matched Subject</th>";
		echo "<th class='heading'>Details</th>";
		echo "</tr>";
		while ($row = mysql_fetch_assoc($result)) {			    
			echo "<tr><td colspan='5' class='content'><p align=\"left\">Suspects Name:<b>". $row['lastname'] ." ".$row['firstname']." Uploader Ip(".$row['clientIp'].")</b></a></p></td></tr>";
			
			if(strlen($row['facePath'])>0){
				echo "<tr><td class='content'><b>Face : </b></td>";
				echo "<td><img src=\"". $row['facePath']."\" width=\"200\" ></td>" ;
				echo "<td class='content'><div align=center>".$row['faceScored']."</div></td>";
				echo "<td class='content'><div align=center><img src=\"". $row['faceMatchedPath']."\" width=\"200\" ></div></td>" ;
				
				$arr = explode(";", $row['faceMatchedRemark']);
				$details = colValue($arr);
				echo "<td class='content'><div align=center>".$details."</div></td></tr>";
			   }
			  
			if(strlen($row['fingerPath'])>0){
			    echo "<tr><td class='content'><b>Fingerprint : </b></td>";
				echo "<td><img src=\"". $row['fingerPath']."\" width=\"200\" ></td>" ;
				echo "<td class='content'><div align=center>".$row['fingerScored']."</div></td>";
			    echo "<td class='content'><div align=center><img src=\"". $row['fingerMatchedPath']."\" width=\"200\" ></div></td>" ;
				
				$arr = explode(";", $row['fingerMatchedRemark']);
				$details = colValue($arr);
				echo "<td class='content'><div align=center>".$details."</div></td></tr>";			  
			}
			   
			if(strlen($row['irisPath'])>0){
				 echo "<tr><td class='content'><b>Iris : </b></td>";
				echo "<td><img src=\"". $row['irisPath']."\" width=\"200\" ></td>" ;
				echo "<td class='content'><div align=center>".$row['irisScored']."</div></td>";
				echo "<td><div align=center><img src=\"". $row['irisMatchedPath']."\" width=\"200\" ></div></td>" ;
				
				$arr = explode(";", $row['irisMatchedRemark']);
				$details = colValue($arr);
				echo "<td class='content'><div align=center>".$details."</div></td></tr>";			   
				
			}
			   
			if(strlen($row['eyesPath'])>0){
				echo "<tr><td class='content'><b>Eye : </b></td>";
				echo "<td><img src=\"". $row['eyesPath']."\" width=\"200\" ></td>" ;
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
		
		echo "</table>";
		echo "<br>";
		echo "<table width='780' border='0' align='center' cellpadding='0' cellspacing='0'>";
		echo "<tr><td  class='content'><p align=\"left\">Copyright © 2013 Department of Computing, The Hong Kong Polytechnic University. All rights reserved.  </p></td></tr>";
		echo "</table>";	
		echo "<br>";		
		mysql_free_result($result);

  }else{
Header( "Location: login.php" );   }
?>	   
	  
