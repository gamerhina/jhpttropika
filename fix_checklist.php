<?php
$mysqli = new mysqli("localhost", "root", "", "jhpttropika34");

$query = "SELECT * FROM journal_settings WHERE setting_name = 'submissionChecklist'";
$result = $mysqli->query($query);
while($row = $result->fetch_assoc()) {
    $value = $row['setting_value'];
    // If it's not JSON
    if (json_decode($value) === null) {
        // Convert to a valid JSON array of strings, or just empty array to be safe, but let's try to preserve it
        // Or simply delete the row so OJS can recreate the default.
        echo "Found bad checklist. Deleting for now so upgrade can proceed...\n";
        $mysqli->query("DELETE FROM journal_settings WHERE setting_name = 'submissionChecklist' AND journal_id = " . (int)$row['journal_id']);
    }
}
