<?php
$servername = "localhost";
$username   = "yhkywyco_mynoteadmin";
$password   = "X]W=CQ3=5+b=";
$dbname     = "yhkywyco_mynote";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}else{
    echo "succes";
}
?>