<?php
$basename_image = $argv[1];
echo "[DEBUG]basename_image: $basename_image \n"; 

//include("SFTPConnection.php");
include('Net/SFTP.php');

function dosPath($path){
     return str_replace('/', '\\',$path);
}


//1) connect the server
$sftp = new Net_SFTP('csdoor2.comp.polyu.edu.hk');
if(!$sftp->login('biomet', 'saospiet')){
   exit('Login Failed');
}

#For cross-platform
#define('DS','/');
#define('BASE_ROOT', str_replace('\\', DS,dirname(__FILE__)));
$default_server_dir = "/home/biomet/public_html/project";
$default_local_dir = "/biomet/";;
echo $sftp->pwd() ."\r\n";

$arr = array (
       "eyesPath" => "suspectsUpload/eyes"
	   #"irisPath" => "suspectsUpload/iris",
	  #"facePath" => "suspectsUpload/face",
	  # "fingerPath" => "suspectsUpload/finger"
);

 //4) -- auto upload the matched image to the server
//the function file_get_contents cannot support bmp file
// defined windows local dir

$windows_local_dir = "/biomet/matched/";
#echo "[DEBUG]windows_dir: $windows_dir \n";
#echo "[DEBUG]base_image: $basename_image \n";
$real_local_dir = $windows_local_dir . $basename_image;
#echo "[DEBUG]real_local_dir: $real_local_dir \n"; 
$image_dir = realpath($real_local_dir) ;
echo "[DEBUG]image_dir: $image_dir \n"; 
//$image_contents = file_get_contents("c:\php\autoload\matched\138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg");

$image_contents = file_get_contents($image_dir);

//cd to the defined dir
$remote_dir = '/home/biomet/public_html/project/suspectsUpload/matched';
$sftp->chdir($remote_dir);

$sftp->put($basename_image, $image_contents);


?>
