<?php

//include("SFTPConnection.php");
include('Net/SFTP.php');

function dosPath($path){
     return str_replace('/', '\\',$path);
}


function makedir($dir){
     if(file_exists($dir) && is_dir($dir)){
	 echo "[DEBUG]:dir $dir exists \n";
    }
    else {
	 echo "[DEBUG]:dir $dir not exists \n";
	 echo "[DEBUG]:mkdir $dir \n";
		 #mkdir the dir	
		 #NOTICE: realpath function only work if the dir exists
         #$local = realpath("$windows_dir"); 
	 mkdir($dir);		 
   }
}

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
$windows_local_dir = "/biomet/matched/";
$default_local_dir = "/biomet/";
#$default_local_dir = realpath($default_local_dir);

echo $sftp->pwd() ."\r\n";

#mkdir  the related local dir if it doesnot exist	
makedir($default_local_dir);
makedir($windows_local_dir);

$windows_local_dir = dosPath("$windows_local_dir");	
echo "[DEBUG]:windows_local_dir:$windows_local_dir\n";

$arr = array (
       "eyesPath" => "suspectsUpload/eyes"
	   #"irisPath" => "suspectsUpload/iris",
	  #"facePath" => "suspectsUpload/face",
	  # "fingerPath" => "suspectsUpload/finger"
);

foreach ( $arr as $key => $value) {
    #For eyes, iris, face, finger
    echo "[DEBUG]:$key => $value\n";
	
	#mkdir a related local dir if it doesnot exist	
	$local_dir = $default_local_dir . $key ;
	#dosPath("$default_local_dir/$key");	
	echo "[DEBUG]:local_dir:$local_dir\n";
	makedir($local_dir);
	
	#on the local, switch to the related defiend dir
	#c:/php/autoload/eyesPath
	chdir($local_dir);
	#on the server, switch to the related defined dir
	#/home/biomet/public_html/project/suspectsUpload/eyes
	$server_dir = "$default_server_dir/$value";
	$sftp->chdir($server_dir);
	
	#list the images in the dir in the server
	$list = $sftp->nlist($server_dir);
    print_r($list);
	
	#echo "[DEBUG]:key->$key \n" ;
	#get the related image dir from table biometData
	$sql_isDownload = "select $key from biometData where isDownload = 0;";
    $result = mysql_query($sql_isDownload, $link)
                   or die ('MySQL Error: ' . mysql_error());
				   
    while($row = mysql_fetch_assoc($result)){
	     #echo "[DEBUG]: row:$row[$key]\n";
	     #download each image
	     if (strlen($row[$key])>0) {
		     # the related server dir
			 //echo "[DEBUG]row-key:$row[$key]" ;
		     $image = "$default_server_dir/$row[$key]";
             echo "[DEBUG]:images:$image\n" ;
			 
			 $img = basename($image);
			 echo "[DEBUG]:img:$img\n" ;
			 #get the related image
			 $sftp->get($img, $img);
			 
			 #update the flag in biometData
			 # should have four flags ...
			 $isDownload = "update biometData set isDownload = 1 where eyesPath = '$row[$key]' or irisPath = '$row[$key]' or facePath = '$row[$key]' or fingerPath = '$row[$key]';";
             echo "[DEBUG]:isDownload: $isDownload \n";
			 
             $result_matched = mysql_query($isDownload, $link) 
                     or die ('MySQL Error: ' . mysql_error());
					 
             echo "[DEBUG]update a flag to biometData \n";
		}
    }
}

mysql_close($link);

?>
