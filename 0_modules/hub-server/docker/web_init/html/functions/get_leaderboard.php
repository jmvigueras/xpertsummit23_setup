<?php
//require("class_DevCoder.inc");
//use DevCoder\DotEnv;
//(new DotEnv('/var/www/.env'))->load();

// Get environment variables
$dbhost = $_ENV['DBHOST'];
$dbuser = $_ENV['DBUSER'];
$dbpass = $_ENV['DBPASS'];
$db = $_ENV['DBNAME'];
$table = $_ENV['DBTABLE'];

$con = mysqli_connect($dbhost,$dbuser,$dbpass,$db);

if (mysqli_connect_errno()) {
   echo "Error: connecting DB: ".gethostbyname($dbhost);
   exit;
}

$sql = "SELECT `user_id`,`server_ip`,`server_check` FROM ".$table." WHERE server_test=1 ORDER BY server_check";
$data='';

if ($result = mysqli_query($con,$sql)) {
    while($row = mysqli_fetch_array($result))
    {
        $data .= '<br> User: <b>' . $row['user_id'] .'</b> ServerIP: '. $row['server_ip'] . ' Time: ' . $row['server_check'];
    }
}
mysqli_close($con);
echo $data;