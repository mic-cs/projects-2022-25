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

$sql = "SELECT * FROM users WHERE phone_number='$phone' OR email='$email'";
$result = $con->query($sql);
$count = $result->num_rows;

if($count > 0){
    // Fetch the user data to check if phone or email is already registered
    $user = $result->fetch_assoc();

    // Check if both phone number and email are already registered
    if ($user['phone_number'] == $phone && $user['email'] == $email) {
        $message = "User already registered with the same phone number and email.";
    }
    // Check if the phone number is already registered
    elseif ($user['phone_number'] == $phone) {
        $message = "User already exists! Try a new phone number.";
    }
    // Check if the email is already registered
    elseif ($user['email'] == $email) {
        $message = "User already exists! Try a new email.";
    }

    $post = array(
        "status" => false,
        "message" => $message,
        "userData" => $data
    );
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
