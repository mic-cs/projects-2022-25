<?php
require 'connection.php';

$userid = $_REQUEST['userid'];
$data = array();

$first_name = $_REQUEST['first_name'];
$last_name = $_REQUEST['last_name'];
$phone = $_REQUEST['phone'];
$email = $_REQUEST['email'];

// Check if the email already exists for another user
$sql_check_email = "SELECT * FROM users WHERE email = ? AND userid != ?";
$stmt_check_email = $con->prepare($sql_check_email);
$stmt_check_email->bind_param("si", $email, $userid); // Check for duplicate email
$stmt_check_email->execute();
$res_check_email = $stmt_check_email->get_result();

if ($res_check_email->num_rows > 0) {
    $data = array("status" => false, "message" => "The email address is already exists.");
    echo json_encode($data);
    exit; // Stop further execution if email is already in use
}

$stmt_check_email->close();

// Check if the phone number already exists for another user
$sql_check_phone = "SELECT * FROM users WHERE phone_number = ? AND userid != ?";
$stmt_check_phone = $con->prepare($sql_check_phone);
$stmt_check_phone->bind_param("si", $phone, $userid); // Check for duplicate phone number
$stmt_check_phone->execute();
$res_check_phone = $stmt_check_phone->get_result();

if ($res_check_phone->num_rows > 0) {
    $data = array("status" => false, "message" => "The phone number is already exists.");
    echo json_encode($data);
    exit; // Stop further execution if phone number is already in use
}

$stmt_check_phone->close();

// Update user information in the database
$sql_update = "UPDATE users SET first_name = ?, last_name = ?, email = ?, phone_number = ? WHERE userid = ?";
$stmt_update = $con->prepare($sql_update);
$stmt_update->bind_param("ssssi", $first_name, $last_name, $email, $phone, $userid); // Use bind_param for security

if ($stmt_update->execute()) {
    $data = array("status" => true, "message" => "Update successful");
} else {
    $data = array("status" => false, "message" => "Update failed: " . $stmt_update->error);
}

$stmt_update->close(); // Close statement
$con->close(); // Close connection

// Return response
echo json_encode($data);
?>
