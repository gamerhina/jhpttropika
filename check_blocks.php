<?php
require 'config.inc.php';
$c = mysqli_connect('localhost', 'root', '', 'jhpttropika34');
$blocks = ['quick-menu', 'lembaga-indeks', 'scimago-rank', 'sinta-2637b0a955213b', 'visitors', 'scopus-index', 'google-scholar-citations'];

foreach($blocks as $b) {
    echo "Block: $b\n";
    $plugin_name = "customblockmanagerplugin"; // or $b ?
    $r = mysqli_query($c, "SELECT plugin_name, setting_name, setting_value FROM plugin_settings WHERE plugin_name = '$b' OR plugin_name = '{$b}blockplugin'");
    while($row = mysqli_fetch_assoc($r)) {
        echo "  " . $row['setting_name'] . ": " . substr($row['setting_value'], 0, 100) . "\n";
    }
}
