<?php
$con=new mysqli("localhost","root","","aqua_farm");
if(!$con)
{
  die("sql connection error");
}
$server_path="../upload";
$base_path="../upload/";
?>