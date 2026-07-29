<?php
$filesToDelete = [
    'fix_speed.php',
    'fix_index.php',
    'check_db.php',
    'clear_cache.php',
    'enable_plugins.php',
    'profile_slow.log',
    'profile_article.log',
    'time_log.txt',
    basename(__FILE__) // Menghapus dirinya sendiri
];

$deleted = [];
foreach ($filesToDelete as $file) {
    $path = __DIR__ . '/' . $file;
    if (file_exists($path)) {
        if (unlink($path)) {
            $deleted[] = $file;
        }
    }
}

echo "Berhasil menghapus file dari server publik secara permanen:\n";
foreach ($deleted as $d) {
    echo "- $d\n";
}
echo "\nSekarang file-file tersebut sudah 100% musnah dan tidak bisa diakses siapapun dari URL.";
