<?php

include("SFTPConnection.php");

//try {
/*
    $sftp = new SFTPConnection('csdoor2.comp.polyu.edu.hk', 22);
    echo "Could not select database" ."\n";
    $sftp->login("biomet", "saospiet");
    echo "hello" . "\n";
    $sftp->uploadFile("/home/zhaowenlong/workspace/proj/dev.php/ftpclass.php", "/webhome/biomet/public_html/ftpclass.php");
*/
//}
//catch (Exception $e) {
//    echo $e->getMessage() . "\n";
//}

/*
$connection = ssh2_connect('csdoor2.comp.polyu.edu.hk', 22);

$auth_methods = ssh2_auth_none($connection, 'user');
echo "Could not" . "\n";
$stdio_stream = ssh2_shell($connection);
echo "Could not con" . "\n";
fwrite($stdio_stream,biomet."\n");
echo "Could not connect" . "\n";
sleep(1); 
fwrite($stdio_stream,saospiet."\n"); 
echo "Could not connect the" . "\n";
sleep(1); 
echo "Output: " . stream_get_contents($stdio_stream);
*/
/*
$script = "ls";
$connection = ssh2_connect('csdoor2.comp.polyu.edu.hk', 22);
echo "Could not" . "\n";
ssh2_auth_password($connection, 'biomet', 'saospiet');
//$shell=ssh2_shell($connection, 'xterm'); 
echo "Could not the" . "\n";
//fwrite( $shell, "ls -la\n"); 
$stream = ssh2_exec($connection, $script);
echo "Could not the stream" . "\n";
*/


include('Net/SFTP.php');

$image = 'logo.jpg';

$image_contents = file_get_contents($image);

$sftp = new Net_SFTP('csdoor2.comp.polyu.edu.hk');
if(!$sftp->login('biomet', 'saospiet')){
   exit('Login Failed');
}

echo $sftp->pwd() ."\r\n";
//cd to the defined dir
$remote_dir = '/home/biomet/public_html/project/suspectsUpload/matched';
$sftp->chdir($remote_dir);

$sftp->put($image, $image_contents);

$image_dir = '/home/biomet/public_html/project/suspectsUpload/face/';
$local_dir = '/home/zhaowenlong/workspace/proj/dev.php/face/';
$sftp->chdir($image_dir);
chdir($local_dir);

//print_r($sftp->nlist($image_dir));
$arr = $sftp->nlist($image_dir);
print_r($arr);
foreach($arr as $k => $img){
   echo "DEBUG:\$arr[$k] => $img\n";
   
   $sftp->get($img, $img);
}

//update the database

//connect to the database
$link = mysql_connect('mysql.comp.polyu.edu.hk:3306', 'biomet', 'qwkdjmxn') 
        or die('Unable to connect: ' . mysql_error());

//select a database to work with
if(!mysql_select_db('biomet', $link)){
    echo 'Could not select database';
    exit;
}

//Assume logo.jpg from the camera matches some picture, for example 140679558033-280Koala.jpg
//1) fetch the related information of 140679558033-280Koala.jpg from table biometData
//   -- idbiometData
//   select idbiometData from biometData where facePath='suspectsUpload/face/140679558033-280Koala.jpg';
//2) insert the information of the picture into table fingerMatchResulted
//   --select max(idfaceMatchResulted) from faceMatchResulted
//   -- insert into 
//2)
//execute the SQL query and return records
$sql = "select idbiometData, facePath,userName, clientIp from biomet.biometData where userName = 'wenlzhao';";

$result = mysql_query($sql, $link);

if(!$result) {
    echo "DB Error, could not query the database\n";
    echo 'MySQL Error:'. mysql_errot();
    exit;
} else {
   //fetch the data
   while($row = mysql_fetch_array($result)){
     echo "idbiometData:".$row{'idbiometData'}." facePath:".$row{'facePath'}." clientIp:".$row    {'clientIp'}."\n";
  }
}
//close the connection
mysql_close($link);


?>
