<?php
// Enable error reporting
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Get POST data (JSON body)
$data = json_decode(file_get_contents("php://input"), true);

// Log received data for debugging
error_log("Received data: " . json_encode($data));

// Extract values from the JSON data
$quantity = $data['quantity'] ?? null;
$type = $data['type'] ?? null;
$date = $data['date'] ?? null;
$time = $data['time'] ?? null;

// Check if any required data is missing
if (!$quantity || !$type || !$date || !$time) {
    echo json_encode(["status" => false, "message" => "Missing data"]);
    exit();
}

require 'connection.php';

// Check if data already exists for this date, time, and type
$sql1 = "SELECT * FROM sensor_data WHERE date='$date' AND time='$time' AND type='$type'";
$result1 = $con->query($sql1);
$count1 = $result1->num_rows;

if ($count1 > 0) {
    echo json_encode(["status" => false, "message" => "Data for this date, time, and type already exists"]);
} else {
    // Insert new data into the database
    $sql = "INSERT INTO sensor_data (quantity, type, date, time)
        VALUES ('$quantity', '$type', '$date', '$time')";

    // Execute the query
    if ($con->query($sql) === TRUE) {
        echo json_encode(["status" => true, "message" => "Data inserted successfully"]);
    } else {
        // Log any error with the SQL query
        error_log("Error inserting data: " . $con->error);
        echo json_encode(["status" => false, "message" => "Data Insertion Failed"]);
    }
}

$con->close();
?>
