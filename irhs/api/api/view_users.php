<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

require 'connection.php';

// SQL query to fetch all users
$sql = "SELECT userid, first_name, last_name, email, phone_number FROM users";

$result = $con->query($sql);

if ($result->num_rows > 0) {
    $users = [];
    while ($row = $result->fetch_assoc()) {
        $users[] = [
            'userid' => $row['userid'],
            'first_name' => $row['first_name'],
            'last_name' => $row['last_name'],
            'email' => $row['email'],
            'phone_number' => $row['phone_number']
        ];
    }
    echo json_encode(["status" => true, "data" => $users]);
} else {
    echo json_encode(["status" => false, "message" => "No users found"]);
}

$con->close();
?>
