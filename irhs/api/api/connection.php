<?php
$con=new mysqli("localhost","root","Neontetra@2021#","rain_water");
if(!$con)
{
  die("sql connection error");
}
$server_path=$_SERVER['DOCUMENT_ROOT']."/Project/rain_water/upload";
$base_path="http://campus.sicsglobal.co.in/Project/rain_water/upload/";
?>