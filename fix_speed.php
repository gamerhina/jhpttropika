<?php
$config = parse_ini_file('config.inc.php', true);
$db = $config['database'];

$pluginsToDisable = [
    'externalfeedplugin',
    'scimago-rank',
    'scopus-index',
    'sinta-2637b0a955213b',
    'google-scholar-citations'
];

try {
    $pdo = new PDO("mysql:host=127.0.0.1;dbname=" . $db['name'], $db['username'], $db['password']);
    
    echo "Mematikan plugin eksternal yang sering membuat lambat (timeout)...\n";
    
    foreach ($pluginsToDisable as $pluginName) {
        $stmt = $pdo->prepare("UPDATE plugin_settings SET setting_value = '0' WHERE plugin_name = ? AND setting_name = 'enabled'");
        $stmt->execute([$pluginName]);
        echo "- Plugin $pluginName dinonaktifkan.\n";
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
