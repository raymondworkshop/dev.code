<?php 
	$fp = fopen("counterlog.txt", "r");
	$count = fread($fp, 1024);
	fclose($fp);
	$count = $count + 1;
	echo $count;
	$fp = fopen("counterlog.txt", "w");
	fwrite($fp, $count);
	fclose($fp);
?>
