<?php
$configContent = file_get_contents('config.inc.php');
preg_match('/\[database\](.*?)\[/s', $configContent, $dbBlockMatch);
$dbBlock = $dbBlockMatch[1] ?? $configContent;
preg_match('/^\s*username\s*=\s*(.*?)$/m', $dbBlock, $u);
preg_match('/^\s*password\s*=\s*(.*?)$/m', $dbBlock, $p);
preg_match('/^\s*name\s*=\s*(.*?)$/m', $dbBlock, $n);
preg_match('/^\s*host\s*=\s*(.*?)$/m', $dbBlock, $h);

$dbUser = trim($u[1] ?? '', "\r\n\t '\"");
$dbPass = trim($p[1] ?? '', "\r\n\t '\"");
$dbName = trim($n[1] ?? '', "\r\n\t '\"");
$dbHost = trim($h[1] ?? 'localhost', "\r\n\t '\"");

try {
    $pdo = new PDO("mysql:host=$dbHost;dbname=$dbName", $dbUser, $dbPass);
    $pluginsToDisable = ['externalfeedplugin', 'crossrefplugin', 'citationstylelanguageplugin', 'dataciteplugin'];
    foreach ($pluginsToDisable as $pluginName) {
        $stmt = $pdo->prepare("UPDATE plugin_settings SET setting_value = '0' WHERE plugin_name = ? AND setting_name = 'enabled'");
        $stmt->execute([$pluginName]);
    }
} catch (Exception $e) {
    echo "========================================\n";
    echo "ERROR FATAL: KONEKSI DATABASE GAGAL!\n";
    echo "Pesan: " . $e->getMessage() . "\n";
    echo "========================================\n";
    echo "Plugin tidak berhasil dimatikan karena password/username tidak terbaca.\n";
}

echo "Membersihkan SELURUH Cache OJS secara total (agar perubahan berdampak ke Sidebar)...\n";

$dirs = ['cache/', 'cache/t_cache/', 'cache/t_compile/'];
foreach($dirs as $dir) {
    $files = glob($dir . '*.php');
    foreach($files as $file) {
        if(is_file($file) && basename($file) != 'index.php') {
            unlink($file);
        }
    }
}
echo "Cache berhasil dibersihkan total!\n";
echo "Silakan refresh halaman artikel Anda. (Refresh pertama akan butuh 15 detik, refresh kedua harusnya kilat).";
