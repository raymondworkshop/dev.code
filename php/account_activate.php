<?php
	$accountId = $_GET['idLogin'];
	$randId = $_GET['randId'];

	echo "<br>";
	$message = "";
	if (($accountId == "")||($randId == ""))
	$message = "Invalid entrypoint";
				
	//check existing user
	$link = mysql_connect('mysql.comp.polyu.edu.hk', 'biomet', 'qwkdjmxn');

	if (!$link) {
		die('Could not connect: ' . mysql_error());
		}

	if (!mysql_select_db('biomet', $link)) {
		echo 'Could not select database';
		exit;
		}
	$sqlHasUpdated ='select userName from biometLogin where activate = True and idbiometLogin ='.$accountId.' and randId ='.$randId.';';
	$resultUpdated = mysql_query($sqlHasUpdated, $link);
	$numResults = mysql_num_rows($resultUpdated);
	
	if($numResults>0){
		mysql_free_result($resultUpdated);
		mysql_close($link);
		echo "A Confirmation e-mail has ALREADY been sent";
	
	}else
	{
		$sql    = 'UPDATE  biometLogin SET activate = True where idbiometLogin ='.$accountId.' and randId ='.$randId.';';
		$result = mysql_query($sql, $link);

		if (!$result) {
			echo "DB Error, could not query the database\n";
			echo 'MySQL Error: ' . mysql_error();
			exit;
			}
			
		//select new registed data's account ID for activation purpose
		$sqlNewId ='select userEmail,userName from biometLogin where idbiometLogin ='.$accountId.' and randId ='.$randId.';';
		$resultUser = mysql_query($sqlNewId, $link);
		$userEmail = mysql_result($resultUser, 0,userEmail);
		$userName = mysql_result($resultUser, 0,userName);
		
		//send email
		$to = $userEmail;
		 $subject = "Watchlist Officer Account Activation ";
		 $message = "Dear Watchlist Officers,\n\t";
		 $message .= "\n\t";
		 $message .= "Your registration request to use 'Automated Watchlist Identification System for Border Crossing' has been approved.\n\t";
		 $message .= "\n\t";
		 $message .= "Your User Name: ".$userName."\n\t";
		 $message .= "\n\t";
		 $message .= "Please login and proceed Watchlist details using following weblink";
		 $message .= "Login Page: http://biomet.comp.polyu.edu.hk/project/login.php";
		 $message .= "\n\t";
		 $from = "csajaykr@comp.polyu.edu.hk";
	//	$from = "lauohung@gmail.com";
		 $headers = "From:" . $from;
		 mail($to,$subject,$message,$headers);
		
		mysql_free_result($resultUpdated);
		mysql_free_result($resultUser);
		mysql_close($link);

	//	 echo "<script>window.close();</script>";
		echo "A Confirmation e-mail has been sent";
	

	}
?>