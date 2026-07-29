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
    
    echo "Sedang memperbaiki database Anda... mohon tunggu beberapa detik...\n";
    
    // Coba tambahkan Index pada submission_id (Jika belum ada, ini akan memperbaiki masalah 12 detik!)
    try {
        $pdo->exec("ALTER TABLE metrics_submission ADD INDEX idx_speed_submission_id (submission_id)");
        echo "- Index berhasil ditambahkan ke tabel metrics_submission!\n";
    } catch (Exception $e) {
        echo "- Index sudah ada di metrics_submission atau error: " . $e->getMessage() . "\n";
    }

    try {
        $pdo->exec("ALTER TABLE metrics_old ADD INDEX idx_speed_submission_id_old (submission_id)");
        echo "- Index berhasil ditambahkan ke tabel metrics_old!\n";
    } catch (Exception $e) {
        // Abaikan jika sudah ada
    }

    // Index tambahan untuk assoc_id jika sering di-query
    try {
        $pdo->exec("ALTER TABLE metrics_submission ADD INDEX idx_speed_assoc_id (assoc_id)");
    } catch (Exception $e) {}

    echo "\nSelesai! Index database telah dioptimasi.\n";
    echo "Silakan coba buka halaman artikel Anda sekarang. Harus langsung melesat kencang!\n";
    
} catch (Exception $e) {
    echo "========================================\n";
    echo "ERROR FATAL: KONEKSI DATABASE GAGAL!\n";
    echo "Pesan: " . $e->getMessage() . "\n";
    echo "========================================\n";
}
