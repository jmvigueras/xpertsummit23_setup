<?php
// define variables and set to empty values
$email = $exit = "";
$dbhost = $dbuser = $dbpass = $db = $table = $mysqli = $sql = $result = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (empty($_POST["email"])) {
        $exit = "Email is required";
    } else {
        $email = $_POST['email'];
        // check if e-mail address is well-formed
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
          $exit = "Invalid email format";
        } else {
            // Get environment variables
            $dbhost = $_ENV['DBHOST'];
            $dbuser = $_ENV['DBUSER'];
            $dbpass = $_ENV['DBPASS'];
            $db = $_ENV['DBNAME'];
            $table = $_ENV['DBTABLE'];   

            #echo $dbhost. $dbuser. $dbpass. $db;
            $con = mysqli_connect($dbhost,$dbuser,$dbpass,$db);   

            if (mysqli_connect_errno()) {
                $exit = "Error: connecting DB: ". mysqli_connect_error();
            } else {
                $exit = "User not found";
                $sql = "SELECT * FROM " . $table ." WHERE email='".$email."'"; 
                if ($result = mysqli_query($con,$sql)) {
                    while($row = mysqli_fetch_array($result))
                    {
                        $exit = '<br> tags: <br>';
                        $exit .= '   Owner = "' . $row['user_id'] . '"<br>';
                        $exit .= '   Name  = "' . $row['user_sort'] . '"<br>';
                        $exit .= '<br> region: <br>';
                        $exit .= '   region     = "' . $row['region']. '"<br>';
                        $exit .= '   region_az1 = "' . $row['region_az1']. '"<br>';
                        $exit .= '<br> account_id  = "' . $row['accountid'].'"';
                        $exit .= '<br> vpc_cidr    = "' . $row['vpc_cidr'].'"';
                        $exit .= '<br> hub_fgt_pip = "' . $row['hub_fgt_pip'].'"';
                        $exit .= '<br>';
                        $exit .= '<br> cloud9: <br>';
                        $exit .= '   url  = "' . $row['cloud9_url'] . '"<br>';
                        $exit .= '   user = "' . $row['user_id'] . '"<br>';
                        $exit .= '   password = "' . $row['user_password'] . '"';
                        $exit .= '<br>';
                        $exit .= '<br> KEYS: <br>';
                        $exit .= '   access_key = "' . $row['access_key'] . '"<br>';
                        $exit .= '   secret_key = "' . $row['secret_key'] . '"<br>';
                        $exit .= '   externalid_token = "' . $row['externalid_token'] . '"';
                        $exit .= '<br>';
                        $exit .= '<br> FortiCloud: <br>';
                        $exit .= '   account  = "' . $row['account_forticloud'] . '"<br>';
                        $exit .= '   iam_user = "' . $row['user_forticloud'] . '"<br>';
                        $exit .= '   iam_pass = "' . $row['pass_forticloud'] . '"';
                        $exit .= '<br>';   
                        $exit .= '<br>';
                    }
                }
            }
            mysqli_close($con);
        }
    }
}
echo $exit;