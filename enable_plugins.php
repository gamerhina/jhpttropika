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
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Daftar plugin yang sebelumnya kita matikan
    $pluginsToEnable = [
        'citationstylelanguageplugin', // How to Cite
        'acronplugin',                 // Auto Cron / Email Notifikasi
        'crossrefplugin',              // Crossref / DOI
        'resolverplugin',              // Pencarian URL referensi
        'dataciteplugin'               // DataCite
    ];
    
    echo "Sedang mengaktifkan kembali plugin-plugin penting...\n";
    foreach ($pluginsToEnable as $pluginName) {
        $stmt = $pdo->prepare("UPDATE plugin_settings SET setting_value = '1' WHERE plugin_name = ? AND setting_name = 'enabled'");
        $stmt->execute([$pluginName]);
        echo "- Plugin '$pluginName' berhasil DIAKTIFKAN kembali.\n";
    }

} catch (Exception $e) {
    echo "========================================\n";
    echo "ERROR FATAL: KONEKSI DATABASE GAGAL!\n";
    echo "Pesan: " . $e->getMessage() . "\n";
    echo "========================================\n";
}

echo "Membersihkan Cache OJS secara total...\n";

// Bersihkan cache template OJS
$cacheDirs = ['t_compile', 't_cache', 't_config', '_db'];
foreach ($cacheDirs as $dir) {
    $fullPath = __DIR__ . '/cache/' . $dir;
    if (is_dir($fullPath)) {
        $files = glob($fullPath . '/*');
        foreach ($files as $file) {
            if (is_file($file) && basename($file) !== '.gitignore') {
                unlink($file);
            }
        }
    }
}

// Bersihkan file cache utama
$files = glob(__DIR__ . '/cache/*.php');
foreach ($files as $file) {
    if (is_file($file)) {
        unlink($file);
    }
}

echo "\nSelesai! Plugin sudah diaktifkan dan cache sudah dibersihkan.\n";
echo "Silakan cek halaman artikel Anda, harusnya fitur 'How to Cite' dll sudah muncul dan kecepatan tetap sekejap mata!\n";
