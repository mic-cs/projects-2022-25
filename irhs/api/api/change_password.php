<?php
require 'connection.php';

$userid = $_REQUEST['userid'];
$current_password = $_REQUEST['current_password']; 
$new_password = $_REQUEST['new_password']; 

$data = array();

$sql = "SELECT * FROM users WHERE userid = ?";
$stmt = $con->prepare($sql);
$stmt->bind_param("i", $userid);
$stmt->execute(); 
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();


    if ($user['password'] === $current_password) {

        if (strlen($new_password) < 6) {
            $data = array("status" => false, "message" => "New password must be at least 6 characters long");
        } else {

            $update_sql = "UPDATE users SET password = ? WHERE userid = ?";
            $update_stmt = $con->prepare($update_sql);
            $update_stmt->bind_param("si", $new_password, $userid);

            if ($update_stmt->execute()) {
                $data = array("status" => true, "message" => "Password changed successfully");
            } else {
                $data = array("status" => false, "message" => "Failed to change password: " . $update_stmt->error);
            }
            $update_stmt->close();
        }
    } else {
        $data = array("status" => false, "message" => "Current password is incorrect");
    }
} else {
    $data = array("status" => false, "message" => "User not found");
}

$stmt->close();
$con->close();


echo json_encode($data);
?>
