<?php
$c = mysqli_connect('localhost', 'root', '', 'jhpttropika34');
$r = mysqli_query($c, "SELECT setting_value FROM plugin_settings WHERE plugin_name = 'google-scholar-citations' AND setting_name = 'blockContent'");
while($row = mysqli_fetch_assoc($r)) {
    echo "DB Value: " . $row['setting_value'] . "\n";
    print_r(json_decode($row['setting_value'], true));
}
