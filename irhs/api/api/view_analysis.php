<?php
// Enable error reporting
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Get the current month and year
$currentMonth = date('m');
$currentYear = date('Y');

require 'connection.php';

// SQL query to calculate the average quantity for 'rain' and 'usage' grouped by date
$sql = "
    SELECT 
        date,
        type,
        AVG(quantity) AS average_quantity
    FROM 
        sensor_data
    WHERE 
        MONTH(date) = '$currentMonth' AND YEAR(date) = '$currentYear'
    GROUP BY 
        date, type
    ORDER BY 
        date ASC, type ASC
";

$result = $con->query($sql);

if ($result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = [
            'date' => $row['date'],
            'type' => $row['type'],
            'average_quantity' => round($row['average_quantity'], 2) // Round to 2 decimal places
        ];
    }
    echo json_encode(["status" => true, "data" => $data]);
} else {
    echo json_encode(["status" => false, "message" => "No data found for the current month"]);
}

$con->close();
?>
