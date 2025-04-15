<?php
require 'connection.php';

$userid = $_REQUEST['userid'];
$data = array();

$first_name = $_REQUEST['first_name'];
$last_name = $_REQUEST['last_name'];
$phone = $_REQUEST['phone'];
$email = $_REQUEST['email'];

// Get current phone and email for the user
$sql_get_current = "SELECT phone_number, email FROM users WHERE userid = ?";
$stmt_get_current = $con->prepare($sql_get_current);
$stmt_get_current->bind_param("i", $userid);
$stmt_get_current->execute();
$res_get_current = $stmt_get_current->get_result();

if ($res_get_current->num_rows > 0) {
    $current_user = $res_get_current->fetch_assoc();
    $current_phone = $current_user['phone_number'];
    $current_email = $current_user['email'];
} else {
    $data = array("status" => false, "message" => "User not found");
    echo json_encode($data);
    exit;
}

$stmt_get_current->close();

// Check if the email is being changed and if the new email already exists
if ($email != $current_email) {
    $sql_check_email = "SELECT * FROM users WHERE email = ? AND userid != ?";
    $stmt_check_email = $con->prepare($sql_check_email);
    $stmt_check_email->bind_param("si", $email, $userid);
    $stmt_check_email->execute();
    $res_check_email = $stmt_check_email->get_result();

    if ($res_check_email->num_rows > 0) {
        $data = array("status" => false, "message" => "The email address is already exists.");
        echo json_encode($data);
        exit;
    }

    $stmt_check_email->close();
}

// Check if the phone number is being changed and if the new phone number already exists
if ($phone != $current_phone) {
    $sql_check_phone = "SELECT * FROM users WHERE phone_number = ? AND userid != ?";
    $stmt_check_phone = $con->prepare($sql_check_phone);
    $stmt_check_phone->bind_param("si", $phone, $userid);
    $stmt_check_phone->execute();
    $res_check_phone = $stmt_check_phone->get_result();

    if ($res_check_phone->num_rows > 0) {
        $data = array("status" => false, "message" => "The phone number is already exists.");
        echo json_encode($data);
        exit;
    }

    $stmt_check_phone->close();
}

// Update user information in the database
$sql_update = "UPDATE users SET first_name = ?, last_name = ?, email = ?, phone_number = ? WHERE userid = ?";
$stmt_update = $con->prepare($sql_update);
$stmt_update->bind_param("ssssi", $first_name, $last_name, $email, $phone, $userid);

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
