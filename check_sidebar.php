<?php
require 'config.inc.php';
$c = mysqli_connect('localhost', 'root', '', 'jhpttropika34');
$r = mysqli_query($c, "SELECT setting_value FROM journal_settings WHERE setting_name='sidebar'");
while ($row = mysqli_fetch_assoc($r)) {
    echo "Sidebar settings: " . $row['setting_value'] . "\n";
}
$r = mysqli_query($c, "SELECT plugin_name, context_id FROM plugin_settings WHERE setting_name='enabled' AND setting_value='1' AND plugin_name LIKE '%block%'");
while ($row = mysqli_fetch_assoc($r)) {
    echo "Enabled block: " . $row['plugin_name'] . " in context " . $row['context_id'] . "\n";
}
