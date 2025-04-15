<?php
require 'connection.php';

$first_name = $_REQUEST['first_name'];
$last_name = $_REQUEST['last_name'];
$phone = $_REQUEST['phone'];
$email = $_REQUEST['email'];
$password = $_REQUEST['password'];
$image = $_FILES['image']['name'];

$data = array();
$post = array();
// $server_url = '/home/ubuntu/html/Project/farmers_Market/api/';

// Check if the phone number or email already exists
$sql = "SELECT * FROM users WHERE phone_number='$phone' OR email='$email'";
$result = $con->query($sql);
$count = $result->num_rows;

if ($count > 0) {
    // Check if the phone number exists
    $sql_phone = "SELECT * FROM users WHERE phone_number='$phone'";
    $result_phone = $con->query($sql_phone);
    $count_phone = $result_phone->num_rows;

    // Check if the email exists
    $sql_email = "SELECT * FROM users WHERE email='$email'";
    $result_email = $con->query($sql_email);
    $count_email = $result_email->num_rows;

    if ($count_phone > 0 && $count_email > 0) {
        $post = array(
            "status" => false,
            "message" => "Phone Number and Email Already Exist",
            "userData" => $data
        );
    } elseif ($count_phone > 0) {
        $post = array(
            "status" => false,
            "message" => "Phone Number Already Exists",
            "userData" => $data
        );
    } elseif ($count_email > 0) {
        $post = array(
            "status" => false,
            "message" => "Email Already Exists",
            "userData" => $data
        );
    }
} else {

    $random_name = rand(1000,1000000) . "-" . $image;
    $image_tmp_name = $_FILES["image"]["tmp_name"];
    $upload_name = strtolower($random_name);
    $upload_name = preg_replace('/\s+/', '-', $upload_name);
    $upload_name = $server_path . "/" . $upload_name;
    
    if(move_uploaded_file($image_tmp_name , $upload_name)){
        $photo = basename($upload_name);
    } else {
        $photo = "";
    }

    $sql = "INSERT INTO `users`(`first_name`, `last_name`, `email`, `phone_number`, `password`, `photo`) 
            VALUES ('$first_name', '$last_name', '$email', '$phone', '$password', '$photo')";
    
    $result = $con->query($sql);
    $count = $con->affected_rows;

    if($count > 0){
        $last_id = $con->insert_id;
        $sq = "SELECT * FROM users WHERE userid=$last_id";
        $res = $con->query($sq);
        $row = $res->fetch_assoc();

        $data[] = array(
            "userid" => ($row['userid'] == null ? "" : $row['userid']),
            "first_name" => ($row['first_name'] == null ? "" : $row['first_name']),
            "last_name" => ($row['last_name'] == null ? "" : $row['last_name']),
            "phone" => ($row['phone_number'] == null ? "" : $row['phone_number']),
            "email" => ($row['email'] == null ? "" : $row['email']),
            "password" => ($row['password'] == null ? "" : $row['password']),
            "photo" => ($row['photo'] == null ? "" : $base_path.$row['photo'])
        );

        $post = array(
            "status" => true,
            "message" => "Registration Successful",
            "userData" => $data
        );
    } else {
        $post = array(
            "status" => false,
            "message" => "Registration Failed",
            "userData" => $data
        );
    }
}

echo json_encode($post);
?>
