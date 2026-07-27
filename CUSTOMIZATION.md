# CUSTOMIZATION.md

Dokumen ini berisi catatan mengenai file-file yang telah dimodifikasi (kustomisasi) untuk jurnal JHPT Tropika agar mudah dikelola dan tidak hilang saat proses _upgrade_ OJS. Seluruh modifikasi *template* telah diletakkan secara aman di dalam folder `plugins/themes/modernthemebihi/`.

## 1. Homepage
Berlokasi di: `plugins/themes/modernthemebihi/templates/frontend/pages/` dan `objects/`
- **indexJournal.tpl**
  (Mengubah struktur beranda jurnal, menambah slider/slideshow, dan penyesuaian blok konten beranda)
- **article_summary_index_journal.tpl**
  (Kustomisasi cara menampilkan ringkasan artikel khusus di halaman depan/beranda)
- **article_slideshow_index_journal.tpl**
  (Modul slideshow kustom untuk menampilkan artikel pilihan/terbaru di beranda)

## 2. Article
Berlokasi di: `plugins/themes/modernthemebihi/templates/frontend/objects/`
- **article_details.tpl**
  (Memodifikasi tampilan halaman baca artikel, mengatur ulang posisi informasi *authors*, afiliasi, tombol galeri PDF, abstrak, dsb.)
- **article_summary.tpl**
  (Memodifikasi tampilan daftar artikel pada halaman arsip edisi / *Table of Contents*, menambahkan nama penulis beserta afiliasinya yang diambil menggunakan parameter `$authorUserGroups`)

## 3. Footer
Berlokasi di: `plugins/themes/modernthemebihi/templates/frontend/components/` (jika ada)
- **footer.tpl**
  (Memodifikasi bagian bawah website jurnal, menambahkan logo Sinta, informasi kontak, counter visitor, dsb.)

## 4. CSS
Berlokasi di: `plugins/themes/modernthemebihi/styles/`
- **new.style.css**
  (Menyimpan seluruh kode warna, *styling* custom, *hover effects*, dan modifikasi tampilan UI *frontend* jurnal)

## 5. PHP Core
Modifikasi sistem PHP Core.
- **pages/issue/IssueHandler.php** (Sebelumnya: *IssueHandler.inc.php*)
  - **Alasan:** Sebelumnya, file sistem inti (Core) OJS ini dimodifikasi untuk melempar/mengirim (assign) data `$authorUserGroups` ke template Manager agar afiliasi *author* bisa terbaca di `article_summary.tpl` dan `article_details.tpl`.
  - **Dampak:** Karena ini adalah file Core OJS, memodifikasi file ini menyebabkan modifikasi akan hilang / ter-overwrite saat melakukan *upgrade* OJS ke versi yang lebih baru (seperti kejadian saat upgrade ke OJS 3.4).
  - **Cara Migrasi:** Kode modifikasi di dalam `IssueHandler.php` telah **DIHAPUS** dan dikembalikan (restore) ke bentuk asli bawaan sistem OJS. Sebagai gantinya, logika penarikan data `$authorUserGroups` tersebut dipindahkan ke dalam file plugin tema: `plugins/themes/modernthemebihi/modernthemebihiThemePlugin.inc.php` menggunakan fitur `Hook::add('TemplateManager::display', ...)`. Dengan cara migrasi ini, saat OJS di-upgrade di masa mendatang, fungsionalitas ini akan tetap aman di dalam plugin tema dan tidak akan hilang.
