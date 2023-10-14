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
                        $exit = '<p>';
                        $exit .= '<b>Variables para actualizar O_UPDATE.tf:</b>';
                        $exit .= '</p>';
                        $exit .= '  tags:<br>';
                        $exit .= '      Owner = "' . $row['user_id'] . '"<br>';
                        $exit .= '      Name  = "' . $row['user_sort'] . '"<br>';
                        $exit .= '<br>';
                        $exit .= '  region:<br>';
                        $exit .= '      id  = "' . $row['region']. '"<br>';
                        $exit .= '      az1 = "' . $row['region_az1']. '"<br>';
                        $exit .= '<br>';
                        $exit .= '  student_vpc_cidr = "' . $row['vpc_cidr']. '"<br>';
                        $exit .= '  hub_fgt_pip = "' . $row['hub_fgt_pip']. '"<br>';
                        $exit .= '  externalid_token = "' . $row['externalid_token'] . '"<br>';
                        $exit .= '  account_id = "' . $row['accountid'] . '"';
                        $exit .= '<p>';
                        $exit .= '<b>Variables para actualizar terraform.tfvars:</b>';
                        $exit .= '</p>';
                        $exit .= '  access_key = "' . $row['access_key'] . '"<br>';
                        $exit .= '  secret_key = "' . $row['secret_key'] . '"';
                        $exit .= '<p>';
                        $exit .= '<b>Acceso a AWS Cloud9 (IAM user): </b>';
                        $exit .= '</p>';
                        $exit .= '  url  = "' . $row['cloud9_url'] . '"<br>';
                        $exit .= '  Account ID = "' . $row['accountid'] . '"<br>';
                        $exit .= '  IAM user name = "' . $row['user_id'] . '"<br>';
                        $exit .= '  Password = "' . $row['user_password'] . '"';
                        $exit .= '<p>';
                        $exit .= '<b>Acceso a FortiWEB y FortiGSLB (IAM LOGIN):</b>';
                        $exit .= '</p>';
                        $exit .= '  account  = "' . $row['account_forticloud'] . '"<br>';
                        $exit .= '  iam_user = "' . $row['user_forticloud'] . '"<br>';
                        $exit .= '  iam_pass = "' . $row['pass_forticloud'] . '"';
                        $exit .= '<p>';
                    }
                }
            }
            mysqli_close($con);
        }
    }
}
echo $exit;