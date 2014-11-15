<?php
//能夠使用 session
session_start();


//檢查用戶有沒有登入
function logincheck()
{
	$userName = (isset($_SESSION[ "userName" ]) ? $_SESSION[ "userName" ] : '');
	if ( $userName == "" )
	{
		Header( "Location: login.php" );
	}
}
?>