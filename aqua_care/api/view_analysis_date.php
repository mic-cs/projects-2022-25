<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

// header('Content-Type: application/json');

require 'connection.php';

$date=$_REQUEST['date'];
$sql = "SELECT * FROM sensor_data WHERE date='$date'";

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
