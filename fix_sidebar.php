<?php
$db = new PDO('mysql:host=127.0.0.1;dbname=jhpttropika34', 'root', '');

// Fix journal_settings
$stmt = $db->query("SELECT journal_id, setting_value FROM journal_settings WHERE setting_name = 'sidebar'");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $sidebar = json_decode($row['setting_value'], true);
    if (is_array($sidebar) && in_array('google-scholar-citations', $sidebar)) {
        $sidebar = array_values(array_filter($sidebar, function($item) {
            return $item !== 'google-scholar-citations';
        }));
        $newSidebar = json_encode($sidebar);
        $updateStmt = $db->prepare("UPDATE journal_settings SET setting_value = ? WHERE setting_name = 'sidebar' AND journal_id = ?");
        $updateStmt->execute([$newSidebar, $row['journal_id']]);
        echo "Removed from journal_settings sidebar\n";
    }
}

// Fix plugin_settings
$stmt2 = $db->query("SELECT context_id, setting_value FROM plugin_settings WHERE plugin_name = 'customblockmanagerplugin' AND setting_name = 'blocks'");
while ($row = $stmt2->fetch(PDO::FETCH_ASSOC)) {
    $blocks = json_decode($row['setting_value'], true);
    if (is_array($blocks) && in_array('google-scholar-citations', $blocks)) {
        $blocks = array_values(array_filter($blocks, function($item) {
            return $item !== 'google-scholar-citations';
        }));
        // OJS stores custom blocks as an object/array, json_encode without numeric keys might be needed if it expects an array or object
        // The original was {"0":"visitors","7":"lembaga-indeks"...} which is an object.
        // Let's encode it with JSON_FORCE_OBJECT if it was an object.
        $newBlocks = json_encode((object)$blocks);
        $updateStmt2 = $db->prepare("UPDATE plugin_settings SET setting_value = ? WHERE plugin_name = 'customblockmanagerplugin' AND setting_name = 'blocks' AND context_id = ?");
        $updateStmt2->execute([$newBlocks, $row['context_id']]);
        echo "Removed from plugin_settings customblockmanagerplugin blocks\n";
    }
}
