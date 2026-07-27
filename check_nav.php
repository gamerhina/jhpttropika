<?php
$mysqli = new mysqli("localhost", "root", "", "jhpttropika34");

$query = "SELECT * FROM navigation_menu_item_settings WHERE setting_value LIKE '%navigation.%' OR setting_value LIKE '%common.%' OR setting_value LIKE '%archive.%'";
$result = $mysqli->query($query);
while($row = $result->fetch_assoc()) {
    print_r($row);
}
