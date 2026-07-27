<?php
/**
 * Quick install check for Scholar Citation Widget plugin
 */
$_SERVER['HTTP_HOST'] = 'localhost';
$_SERVER['REQUEST_URI'] = '/jhpttropika/jhpttropika34/index.php';

define('INDEX_FILE_LOCATION', __DIR__ . '/index.php');

// Just check if the plugin files can be loaded
$pluginPath = __DIR__ . '/plugins/generic/scholarCitationWidget';

echo "=== Scholar Citation Widget - Install Check ===\n\n";

// 1. Check directory
echo "1. Plugin directory: " . (is_dir($pluginPath) ? "EXISTS ✓" : "MISSING ✗") . "\n";

// 2. Check required files
$files = [
    'index.php',
    'version.xml',
    'ScholarCitationWidgetPlugin.php',
    'ScholarCitationWidgetSettingsForm.php',
    'classes/JsonReader.php',
    'classes/Cache.php',
    'classes/Widget.php',
    'templates/sidebar.tpl',
    'templates/settingsForm.tpl',
    'css/widget.css',
    'js/widget.js',
    'locale/en_US/locale.po',
    'locale/id_ID/locale.po',
    'cache/citations.json',
];

echo "\n2. File check:\n";
$allOk = true;
foreach ($files as $file) {
    $fullPath = $pluginPath . '/' . $file;
    $exists = file_exists($fullPath);
    $size = $exists ? filesize($fullPath) : 0;
    $status = $exists ? "✓ ({$size} bytes)" : "✗ MISSING";
    if (!$exists) $allOk = false;
    echo "   {$file}: {$status}\n";
}

// 3. Check citations.json validity
echo "\n3. citations.json validation:\n";
$jsonPath = $pluginPath . '/cache/citations.json';
if (file_exists($jsonPath)) {
    $content = file_get_contents($jsonPath);
    $data = json_decode($content, true);
    if (json_last_error() === JSON_ERROR_NONE) {
        echo "   JSON is valid ✓\n";
        echo "   Profile name: " . ($data['profile']['name'] ?? 'N/A') . "\n";
        echo "   Scholar ID: " . ($data['profile']['scholarId'] ?? 'N/A') . "\n";
        echo "   Citations: " . ($data['metrics']['citations'] ?? 'N/A') . "\n";
        echo "   h-index: " . ($data['metrics']['hindex'] ?? 'N/A') . "\n";
        echo "   i10-index: " . ($data['metrics']['i10index'] ?? 'N/A') . "\n";
        echo "   Chart entries: " . count($data['chart'] ?? []) . "\n";
        echo "   Updated: " . ($data['updated'] ?? 'N/A') . "\n";
    } else {
        echo "   JSON is INVALID ✗ - " . json_last_error_msg() . "\n";
    }
} else {
    echo "   citations.json NOT FOUND ✗\n";
}

// 4. PHP syntax check
echo "\n4. PHP syntax check:\n";
$phpFiles = ['ScholarCitationWidgetPlugin.php', 'ScholarCitationWidgetSettingsForm.php',
             'classes/JsonReader.php', 'classes/Cache.php', 'classes/Widget.php'];
foreach ($phpFiles as $f) {
    $output = shell_exec("php -l " . escapeshellarg($pluginPath . '/' . $f) . " 2>&1");
    $ok = str_contains($output, 'No syntax errors');
    echo "   {$f}: " . ($ok ? "✓ OK" : "✗ ERROR - " . trim($output)) . "\n";
}

echo "\n=== Result: " . ($allOk ? "ALL CHECKS PASSED ✓" : "SOME FILES MISSING ✗") . " ===\n";
echo "\nNext step: Open OJS Admin at:\n";
echo "  http://localhost/jhpttropika/jhpttropika34/index.php/jhpttropika/management/settings/website#plugins\n";
echo "  Look for 'Scholar Citation Widget' in Generic Plugins\n";
