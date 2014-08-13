<?php

//include("SFTPConnection.php");
include('Net/SFTP.php');

function dosPath($path){
     return str_replace('/', '\\',$path);
}

//try {
/*
    $sftp = new SFTPConnection('csdoor2.comp.polyu.edu.hk', 22);
    echo "Could not select database" ."\n";
    $sftp->login("biomet", "saospiet");

    $sftp->uploadFile("/home/zhaowenlong/workspace/proj/dev.php/ftpclass.php", "/webhome/biomet/public_html/ftpclass.php");
*/
//}
//catch (Exception $e) {
//    echo $e->getMessage() . "\n";
//}

/*
$connection = ssh2_connect('csdoor2.comp.polyu.edu.hk', 22);
$auth_methods = ssh2_auth_none($connection, 'user');
$stdio_stream = ssh2_shell($connection);

fwrite($stdio_stream,biomet."\n");

sleep(1); 
fwrite($stdio_stream,saospiet."\n"); 

sleep(1); 
echo "Output: " . stream_get_contents($stdio_stream);
*/
/*
$script = "ls";
$connection = ssh2_connect('csdoor2.comp.polyu.edu.hk', 22);

ssh2_auth_password($connection, 'biomet', 'saospiet');
//$shell=ssh2_shell($connection, 'xterm'); 

//fwrite( $shell, "ls -la\n"); 
$stream = ssh2_exec($connection, $script);
;
*/

//1) download the dataset from the server
//TODO: add parameters to seperate the functions
$sftp = new Net_SFTP('csdoor2.comp.polyu.edu.hk');
if(!$sftp->login('biomet', 'saospiet')){
   exit('Login Failed');
}

//connect to the database
$link = mysql_connect('mysql.comp.polyu.edu.hk:3306', 'biomet', 'qwkdjmxn') 
        or die('Unable to connect: ' . mysql_error());
echo "Connected to MySQL \n";

//select a database to work with
if(!mysql_select_db('biomet', $link)){
    echo 'Could not select database';
    exit;
}

#For cross-platform
#define('DS','/');
#define('BASE_ROOT', str_replace('\\', DS,dirname(__FILE__)));
$default_server_dir = "/home/biomet/public_html/project";
$default_local_dir = "c:/php/autoload";
echo $sftp->pwd() ."\r\n";

$arr = array (
       "eyesPath" => "$default_server_dir/suspectsUpload/eyes"
	   #"irisPath" => "$default_server_dir/suspectsUpload/iris",
	  #"facePath" => "$default_server_dir/suspectsUpload/face",
	  # "fingerPath" => "$default_server_dir/suspectsUpload/finger"
);

foreach ( $arr as $key => $value) {
    #For eyes, iris, face, finger
    echo "[DEBUG]$key => $value\n";
	
	#mkdir a related local dir if it doesnot exist	
	$local_dir = dosPath("$default_local_dir/$key");	
	echo "[DEBUG]local_dir:$local_dir\n";
	
	if(file_exists($local_dir) && is_dir($local_dir)){
	     echo "[DEBUG]dir $local_dir exists \n";
	}
	else {
	     echo "[DEBUG]dir $local_dir not exists \n";
		 #mkdir the dir	
		 #NOTICE: realpath function only work if the dir exists
         #$local = realpath("$local_dir"); 
		 mkdir($local_dir);		 
	}
	
	#on the local, switch to the related defiend dir
	#c:/php/autoload/eyesPath
	chdir($local_dir);
	#on the server, switch to the related defined dir
	#/home/biomet/public_html/project/suspectsUpload/eyes
	$sftp->chdir($value);
	
	#list the images in the dir in the server
	$list = $sftp->nlist($value);
    print_r($list);
	
	#get the related image dir from table biometData
	$sql_isDownload = "select $key from biometData where isDownload = 0;";
    $result = mysql_query($sql_isDownload, $link)
                   or die ('MySQL Error: ' . mysql_error());
				   
    while($row = mysql_fetch_assoc($result)){
	     #download each image
	     if (strlen($row[$key])>0) {
		     # the related server dir
			 //echo "[DEBUG]row-key:$row[$key]" ;
		     $image = "$default_server_dir/$row[$key]";
             echo "[DEBUG]images:$image\n" ;
			 
			 $img = basename($image);
			 echo "[DEBUG]img:$img\n" ;
			 #get the related image
			 $sftp->get($img, $img);
			 
			 #update the flag in biometData
			 # should have four flags ...
			 $flag_isDownload = "update biometData set isDownload = 1 where eyesPath = '$row[$key]' or irisPath = '$row[$key]' or facePath = '$row[$key]' or fingerPath = '$row[$key]';";
             echo "[DEBUG]flag_isDownload: $flag_isDownload \n";
			 
             $result_matched = mysql_query($flag_isDownload, $link) 
                     or die ('MySQL Error: ' . mysql_error());
					 
             echo "[DEBUG]update a flag to biometData \n";
		}
    }
}


// Database operations

//Assume logo.jpg from the camera matches some picture, for example 140696050427-748138217021250-66310_L_5_Eyelid.bmp
//2) fetch the related information of 140696050427-748138217021250-66310_L_5_Eyelid.bmp from table biometData
//   -- idbiometData
 $db_image = "138216560533-88011_L_2_Eyelid.bmp"; //this is returned by the watchlist system
 //$sql = "select idbiometData from biometData where eyesPath='suspectsUpload/eyes/$db_image';";

// $id_biomet =  mysql_result(mysql_query($sql, $link), 0) 
//               or die ('MySQL Error: ' . mysql_error());
// echo "[DEBUG]id_biomet: $id_biomet \n";

//3) insert the information of the picture into table fingerMatchResulted
/*   $sql_max_id = "select MAX(ideyesMatchResulted) from eyesMatchResulted";
   //$result = mysql_query($sql, $link);

   $max_match_id = mysql_result(mysql_query($sql_max_id, $link), 0) 
                   or die ('MySQL Error: ' . mysql_error());
   //echo "[DEBUG]max_match_id: $max_match_id \n"; 
   $insert_match_id = $max_match_id + 1;
   echo "[DEBUG]insert_match_id: $insert_match_id \n";
*/
// get the matched_remark information
$sql_matched_remark = "select firstName, lastName, gender, Age from biometData where eyesPath = 'suspectsUpload/eyes/$db_image';";

$result = mysql_query($sql_matched_remark, $link)
                   or die ('MySQL Error: ' . mysql_error());

$separator = "; ";			   
while($row = mysql_fetch_assoc($result)){
  if (strlen($row['firstName'])>0) {
     $firstname = $row['firstName'] ;
	 $matched_remark = "FirstName: " . $firstname . $separator;
   }
  
   if (strlen($row['lastName'])>0) {
     $lastname = $row['lastName'] ;
	 $matched_remark = $matched_remark . "LastName: " . $lastname . $separator;
   }
 
  if (strlen($row['gender'])>0) {
     $gender = $row['gender'] ;
	 $matched_remark = $matched_remark . "Gender: " . $gender . $separator;
   }

  if (strlen($row['Age'])>0) {
     $age = $row['Age']  ;
	 $matched_remark = $matched_remark . "Gender: " . $age ;
   }
   #$matched_remark = "firstName:" . $firstname . "; lastName:" . $row['lastName'] . "; gender:" . $row['gender'] . "; Age:" . $row['Age'];
    
}
   echo "[DEBUG]matched_remark: $matched_remark\n";
   $matched_scored = 0.6; //returned

   //$path = "c:\php\autoload\matched\138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg";
   //$path = "matched\138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg";
   //$basename_image  = basename($path);
   $basename_image  = "138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg";
   $matched_image = "suspectsUpload/matched/$basename_image";
   echo "[DEBUG]matched_image: $matched_image \n"; 

   //$matched_remark = "the eyes match";
   echo "[DEBUG]matched_remark: $matched_remark \n"; 
   //To match the data in eyesMatchResulted
   $sql_matched = "update eyesMatchResulted e, biometData b set e.matchedScored = 0.6, e.matchedPath ='$matched_image', e.matchedRemark = '$matched_remark' where e.idbiometData = b.idbiometData and b.eyesPath = 'suspectsUpload/eyes/$db_image';  ";
   //$sql_matched = "insert into eyesMatchResulted (ideyesMatchResulted,idbiometData, matchedScored,matchedPath, matchedRemark) values ($insert_match_id,$id_biomet, 0.6, '$matched_image', '$matched_remark');";
   echo "[DEBUG]sql_matched: $sql_matched \n"; 
   $result_matched = mysql_query($sql_matched, $link) 
                     or die ('MySQL Error: ' . mysql_error());
   echo "[DEBUG]update a row to eyesMatchResulted \n";

 //4) -- auto upload the matched image to the server
//the function file_get_contents cannot support bmp file
// defined windows local dir
$windows_dir = "/php/autoload/matched";
$image_dir = realpath("$windows_dir/$basename_image") ;
echo "[DEBUG]image_dir: $image_dir \n"; 
//$image_contents = file_get_contents("c:\php\autoload\matched\138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg");

$image_contents = file_get_contents($image_dir);

//cd to the defined dir
$remote_dir = '/home/biomet/public_html/project/suspectsUpload/matched';
$sftp->chdir($remote_dir);

$sftp->put($basename_image, $image_contents);


//update the database

//connect to the database
$link = mysql_connect('mysql.comp.polyu.edu.hk:3306', 'biomet', 'qwkdjmxn') 
        or die('Unable to connect: ' . mysql_error());

//select a database to work with
if(!mysql_select_db('biomet', $link)){
    echo 'Could not select database';
    exit;
}

//execute the SQL query and return records
$sql = "select idbiometData, eyesPath,userName, clientIp from biomet.biometData where userName = 'wenlzhao';";

$result = mysql_query($sql, $link);

if(!$result) {
    echo "DB Error, could not query the database\n";
    echo 'MySQL Error:'. mysql_errot();
    exit;
} else {
   //fetch the data
   while($row = mysql_fetch_array($result)){
     echo "[DEBUG]idbiometData:".$row{'idbiometData'}." eyesPath:".$row{'eyesPath'}."\n";
  }
}
//close the connection

mysql_close($link);


?>
