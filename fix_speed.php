<?php
$configContent = file_get_contents('config.inc.php');
// Ambil blok [database]
preg_match('/\[database\](.*?)\[/s', $configContent, $dbBlockMatch);
$dbBlock = $dbBlockMatch[1] ?? $configContent;

preg_match('/^username\s*=\s*(.*?)$/m', $dbBlock, $u);
preg_match('/^password\s*=\s*(.*?)$/m', $dbBlock, $p);
preg_match('/^name\s*=\s*(.*?)$/m', $dbBlock, $n);
preg_match('/^host\s*=\s*(.*?)$/m', $dbBlock, $h);

$dbUser = trim($u[1] ?? '', "\r\n\t '\"");
$dbPass = trim($p[1] ?? '', "\r\n\t '\"");
$dbName = trim($n[1] ?? '', "\r\n\t '\"");
$dbHost = trim($h[1] ?? 'localhost', "\r\n\t '\"");

$pluginsToDisable = [
    'externalfeedplugin',
    'scimago-rank',
    'scopus-index',
    'sinta-2637b0a955213b',
    'google-scholar-citations'
];

try {
    $pdo = new PDO("mysql:host=$dbHost;dbname=$dbName", $dbUser, $dbPass);
    
    echo "Menghidupkan kembali plugin eksternal...\n";
    
    foreach ($pluginsToDisable as $pluginName) {
        $stmt = $pdo->prepare("UPDATE plugin_settings SET setting_value = '1' WHERE plugin_name = ? AND setting_name = 'enabled'");
        $stmt->execute([$pluginName]);
        echo "- Plugin $pluginName diaktifkan kembali.\n";
    }
    
    // Clear template cache files roughly
    echo "\nMengosongkan cache template...\n";
    $files = glob('cache/t_compile/*.php');
    foreach($files as $file){
      if(is_file($file))
        unlink($file);
    }
    echo "Selesai! Silakan cek kembali kecepatan website Anda.\n";
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
