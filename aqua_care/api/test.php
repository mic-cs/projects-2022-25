<?php
require 'connection.php';

$ph_value = $_REQUEST['ph_value'];
$temperature = $_REQUEST['temperature'];
$ambience_light = $_REQUEST['ambience_light'];
$oxygen = $_REQUEST['oxygen'];
$water_level = $_REQUEST['water_level'];
$date = $_REQUEST['date'];
$time = $_REQUEST['time'];

$post = array();

// Check if the data already exists (optional, depending on your needs)
$sql = "SELECT * FROM sensor_data WHERE date='$date' and time='$time'"; 
$result = $con->query($sql);
$count = $result->num_rows;

if ($count > 0) {
    $post = array(
        "status" => false,
        "message" => "Data for this date already exists"
    );
} else {
    // Insert new data into sensor_data table
    $sql = "INSERT INTO `sensor_data`(`ph_value`, `temperature`, `ambience_light`, `oxygen`, `water_level`, `date`, `time`) 
            VALUES ('$ph_value', '$temperature', '$ambience_light', '$oxygen', '$water_level', '$date', '$time')";

    $result = $con->query($sql);
    $count = $con->affected_rows;

    if ($count > 0) {
        // Retrieve the inserted data
        $last_id = $con->insert_id;
        $sq = "SELECT * FROM sensor_data WHERE id=$last_id";
        $res = $con->query($sq);
        $row = $res->fetch_assoc();

        $data[] = array(
            "id" => ($row['id'] == null ? "" : $row['id']),
            "ph_value" => ($row['ph_value'] == null ? "" : $row['ph_value']),
            "temperature" => ($row['temperature'] == null ? "" : $row['temperature']),
            "ambience_light" => ($row['ambience_light'] == null ? "" : $row['ambience_light']),
            "oxygen" => ($row['oxygen'] == null ? "" : $row['oxygen']),
            "water_level" => ($row['water_level'] == null ? "" : $row['water_level']),
            "date" => ($row['date'] == null ? "" : $row['date']),
            "time" => ($row['time'] == null ? "" : $row['time']),
        );

        $post = array(
            "status" => true,
            "message" => "Data Added Successfully"
        );
    } else {
        $post = array(
            "status" => false,
            "message" => "Data Insertion Failed"
        );
    }
}

echo json_encode($post);
?>
