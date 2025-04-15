<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
date_default_timezone_set('Asia/Kolkata');

// header('Content-Type: application/json');

require 'connection.php';

$date=date('Y-m-d');

$sql = "SELECT * FROM sensor_data where date='$date' ORDER BY id DESC LIMIT 20";

$result = $con->query($sql);

if ($result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode(["status" => true, "message" => "Data retrieved successfully", "data" => $data]);
} else {
    echo json_encode(["status" => false, "message" => "No data found"]);
}

$con->close();
?>
