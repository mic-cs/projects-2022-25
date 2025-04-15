<?php
// Enable error reporting
ini_set('display_errors', 1);
error_reporting(E_ALL);

require 'connection.php';

// SQL query to fetch distinct month and year
$sql = "
    SELECT DISTINCT 
        DATE_FORMAT(date, '%M') AS month_name, -- Full month name (e.g., January)
        MONTH(date) AS month,                  -- Numeric month (e.g., 1 for January)
        YEAR(date) AS year
    FROM 
        sensor_data
    ORDER BY 
        year DESC, month ASC;                  -- Order by year descending and month ascending
";

$result = $con->query($sql);

if ($result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = [
            'month_name' => $row['month_name'], // Full month name
            'month' => $row['month'],           // Numeric month
            'year' => $row['year']              // Year
        ];
    }
    echo json_encode(["status" => true, "data" => $data]);
} else {
    echo json_encode(["status" => false, "message" => "No data available"]);
}

$con->close();
?>
