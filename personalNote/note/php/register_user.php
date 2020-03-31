<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,VERIFY) VALUES ('$name','$email','$password','1')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}



function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for My.PersonalNote'; 
    $message = 'https://yhkywy.com/mynote/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@mypersonalnote.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>