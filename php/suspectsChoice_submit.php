<?php
#include("suspectsData_submit.php");

			     #action
				 #update the related pictures in table
				if(@$_POST['submit'] ){
				    echo "Update the suspect information\n";
				    @$a = $_POST["choice"];
				     echo "Choice: $a\n";
					 
					 echo "id: $id\n";
					 #delete the value
					 $del_sql = "delete from biometData where idbiometData =";
					echo $image_sql = "insert into biometData (firstname, lastname, gender, Age, facePath, fingerPath, irisPath, eyesPath,userName,clientIp, isDownload) values ('$firstname', '$lastname', '$gender', '$age', '$facePath', '$fingerPath', '$irisPath', '$eyesPath','@$a','$clientIP',0);";
				#	 $image_sql = " delete from biometData where idbiometData = $row['idbiometData'];";
					 #then resubmit
					 
		            # $image_result = mysql_query($image_sql,$link);
		             #$rt_idbiometData = mysql_result($resultData, 0,idbiometData);
		        #     mysql_free_result($image_result);
				}
#?>

#<?php
	include("suspectsData_submit.php");
?>