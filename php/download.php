<?php
/*
 * @author Raymond
 *
 * History:
 *    Augustus-2014 Raymond creation
*/

#$download_object = $argv[1];
$object = $argv[1] . "Path";
echo "\n[DEBUG]download_object: $object \n"; 

//include("SFTPConnection.php");
include('Net/SFTP.php');

function dosPath($path){
     return str_replace('/', '\\',$path);
}

function makedir($dir){
    if(file_exists($dir) && is_dir($dir)){
	     echo "dir $dir exists \n";
    
	}else {
	     echo "dir $dir not exists \n";
	     echo "[DEBUG]:mkdir $dir \n";
		 #mkdir the dir	
		 #NOTICE: realpath function only work if the dir exists
         #$local = realpath("$windows_dir"); 
	     mkdir($dir);		 
   }
}

//1) download the dataset from the server
//add parameters to separate the functions
$sftp = new Net_SFTP('csdoor2.comp.hk');
if(!$sftp->login('biomet', 'saospiet')){
   exit('Login Failed');
}

//connect to the database
$link = mysql_connect('mysql.hk:3306', 'biomet', 'qwkdjmxn') 
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

#The defined array
$arr = array (
       "eyesPath" => "suspectsUpload/eyes",
	   "irisPath" => "suspectsUpload/iris",
	   "facePath" => "suspectsUpload/face",
	   "fingerPath" => "suspectsUpload/finger"
);

#$object = $download_object . "Path";

#foreach ( $arr as $key => $value) {
if( array_key_exists($object, $arr )) {
    #For eyes, iris, face, finger
    echo "[DEBUG]:$object => $arr[$object]\n";
	
	#mkdir a related local dir if it doesnot exist	
	$local_dir = $default_local_dir . $object ;
	#dosPath("$default_local_dir/$object");	
	echo "[DEBUG]:local_dir:$local_dir\n";
	makedir($local_dir);
	
	#on the local, switch to the related defiend dir
	#c:/php/autoload/eyesPath
	chdir($local_dir);
	#on the server, switch to the related defined dir
	#/home/biomet/public_html/project/suspectsUpload/eyes
	$server_dir = "$default_server_dir/$arr[$object]";
	$sftp->chdir($server_dir);
	
	#list the images in the dir in the server
	$list = $sftp->nlist($server_dir);
    print_r($list);
	
	#echo "[DEBUG]:key->$key \n" ;
	#get the related image dir from table biometData
	$flag = $argv[1] . "Download";
	$sql_isDownload = "select $object from biometData where $flag = 0;";
    $result = mysql_query($sql_isDownload, $link)
                   or die ('MySQL Error: ' . mysql_error());
		
    while($row = mysql_fetch_assoc($result)){
	     #echo "[DEBUG]: row:$row[$key]\n";
	     #download each image
	     if (strlen($row[$object])>0) {
		     # the related server dir
			 //echo "[DEBUG]row-key:$row[$key]" ;
		     $image = "$default_server_dir/$row[$object]";
             //echo "[DEBUG]:images:$image\n" ;
			 
			 $img = basename($image);
			 echo "[DEBUG]:img:$img\n" ;
			 #get the related image
			 $sftp->get($img, $img);
			 
			 #update the flag in biometData
			 # the four flags ...
			 $isDownload = "update biometData set $flag = 1 where eyesPath = '$row[$object]' or irisPath = '$row[$object]' or facePath = '$row[$object]' or fingerPath = '$row[$object]';";
             echo "[DEBUG]:isDownload: $isDownload \n";
			 
             $result_matched = mysql_query($isDownload, $link) 
                     or die ('MySQL Error: ' . mysql_error());
					 
             echo "Update the flag to biometData \n";
		}
     }
}
#}

mysql_close($link);

echo "Done \n"; 
?>
