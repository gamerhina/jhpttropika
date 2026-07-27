<?php
require 'config.inc.php';
$c = mysqli_connect('localhost', 'root', '', 'jhpttropika34');

// Enable standard block plugins for journal 1
$blocks = ['makeSubmissionBlockPlugin', 'informationBlockPlugin', 'developedByBlockPlugin', 'languageToggleBlockPlugin'];
foreach ($blocks as $b) {
    mysqli_query($c, "DELETE FROM plugin_settings WHERE plugin_name='$b' AND setting_name='enabled' AND context_id=1");
    mysqli_query($c, "INSERT INTO plugin_settings (plugin_name, context_id, setting_name, setting_value, setting_type) VALUES ('$b', 1, 'enabled', '1', 'bool')");
}

// Set sidebar order
$order = '["makeSubmissionBlockPlugin","informationBlockPlugin","developedByBlockPlugin","languageToggleBlockPlugin"]';
mysqli_query($c, "DELETE FROM journal_settings WHERE setting_name='sidebar' AND journal_id=1");
mysqli_query($c, "INSERT INTO journal_settings (journal_id, setting_name, setting_value, setting_type) VALUES (1, 'sidebar', '$order', 'object')");

echo "Sidebar configured successfully.\n";
