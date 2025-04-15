<?php
require 'connection.php';

$phone = $_REQUEST['phone'];
$password = $_REQUEST['password'];

$data = array();
$post = array();

$sql = "SELECT * FROM users WHERE phone_number='$phone' AND password='$password'";
$result = $con->query($sql);
$count = $result->num_rows;

if($count > 0) {
    $row = $result->fetch_assoc();

    $data[] = array(
        "userid" => ($row['userid'] == null ? "" : $row['userid']),
        "first_name" => ($row['first_name'] == null ? "" : $row['first_name']),
        "last_name" => ($row['last_name'] == null ? "" : $row['last_name']),
        "phone" => ($row['phone_number'] == null ? "" : $row['phone_number']),
        "email" => ($row['email'] == null ? "" : $row['email']),
        "photo" => ($row['photo'] == null ? "" : $base_path.$row['photo'])
    );

    $post = array(
        "status" => true,
        "message" => "Login Successful",
        "userData" => $data
    );
} else {
    $post = array(
        "status" => false,
        "message" => "Invalid phone number or password",
        "userData" => $data
    );
}

echo json_encode($post);
?>
