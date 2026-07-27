# Scholar Citation Widget
**Version 1.0.0** | OJS 3.4.x | PHP ≥ 8.1 | GPL v3

Scholar Citation Widget adalah plugin OJS Generic yang siap produksi untuk menampilkan **metrik Google Scholar** (Total Kutipan, h-index, i10-index) dan **grafik tren kutipan** langsung di sidebar jurnal Anda — tanpa risiko pemblokiran IP atau lambatnya website.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| ✅ Total Citations | Jumlah kutipan keseluruhan |
| ✅ h-index | Indeks H |
| ✅ i10-index | Indeks i10 |
| ✅ Citation Trend Graph | Grafik garis animasi (Chart.js) |
| ✅ Google Scholar Button | Tombol link ke profil Scholar |
| ✅ Last Updated | Timestamp terakhir diperbarui |
| ✅ Dark Mode | Compatible dengan dark mode |
| ✅ Responsive | Mobile, tablet, desktop |
| ✅ No jQuery | Vanilla JavaScript murni |
| ✅ Bilingual | English & Bahasa Indonesia |

---

## Arsitektur

```
Google Scholar (External)
        ↓
ScholarUpdater (Python CLI)  ← Jalankan via Cron/Task Scheduler
        ↓
citations.json (File Lokal)
        ↓
Scholar Citation Widget (PHP Plugin OJS)
        ↓
Chart.js → Sidebar / Homepage
```

Plugin PHP **TIDAK PERNAH** melakukan scraping Google Scholar.
Plugin **HANYA** membaca file `citations.json` lokal.

---

## Struktur File

```
scholarCitationWidget/
├── cache/
│   └── citations.json          ← Data sitasi (diisi oleh Python updater)
├── classes/
│   ├── Cache.php               ← Manajemen TTL cache
│   ├── JsonReader.php          ← Baca & validasi JSON
│   └── Widget.php              ← View-model untuk template
├── css/
│   └── widget.css              ← Styling widget
├── js/
│   └── widget.js               ← Chart.js integration (Vanilla JS)
├── locale/
│   ├── en_US/locale.po         ← English translations
│   └── id_ID/locale.po         ← Indonesian translations
├── templates/
│   ├── sidebar.tpl             ← Template widget sidebar
│   └── settingsForm.tpl        ← Form pengaturan plugin
├── updater/
│   ├── updater.py              ← Main entry point (jalankan ini)
│   ├── parser.py               ← BeautifulSoup4 + Selenium parser
│   ├── config.py               ← Konfigurasi updater
│   ├── logger.py               ← Logging dengan rotasi file
│   ├── output.py               ← Build & tulis citations.json
│   ├── requirements.txt        ← Dependensi Python
│   └── build_zip.py            ← Buat ZIP installer plugin
├── index.php                   ← OJS plugin entry point
├── version.xml                 ← Versi plugin
├── ScholarCitationWidgetPlugin.php
├── ScholarCitationWidgetSettingsForm.php
└── README.md
```

---

## Instalasi

### Opsi A: Upload ZIP (Direkomendasikan)

1. Download file `scholarCitationWidget-v1.0.0.zip`
2. Login OJS sebagai Administrator
3. Buka **Settings → Website → Plugins → Upload a New Plugin**
4. Upload file ZIP tersebut
5. Aktifkan plugin **Scholar Citation Widget**
6. Klik **Settings** dan isi Google Scholar ID Anda

### Opsi B: Manual Copy

1. Copy folder `scholarCitationWidget/` ke direktori:
   ```
   /path/ke/ojs/plugins/generic/scholarCitationWidget/
   ```
2. Ikuti langkah 2-6 di atas

---

## Konfigurasi Plugin

Buka **Settings → Website → Plugins → Scholar Citation Widget → Settings**:

| Field | Keterangan | Default |
|---|---|---|
| **Google Scholar ID** | ID profil Scholar Anda (wajib) | — |
| **Sidebar Title** | Judul block sidebar | `Google Scholar` |
| **Cache Lifetime (Hours)** | TTL cache dalam jam | `24` |
| **Custom JSON File Location** | Path custom ke citations.json | *(default cache/)* |
| **Widget Highlight Color** | Warna aksen widget (hex) | `#014401` |
| **Show Google Scholar Button** | Tampilkan tombol link ke profil | ✅ |
| **Show Citation History Graph** | Tampilkan grafik tren | ✅ |

---

## Setup Python Updater

Python Updater bertugas mengambil data dari Google Scholar dan menyimpannya ke `citations.json`.

### Instalasi Dependensi

```bash
cd plugins/generic/scholarCitationWidget/updater
pip install -r requirements.txt
```

### Menjalankan Updater

```bash
python updater.py --id YOUR_SCHOLAR_ID --output ../cache/citations.json
```

**Contoh:**
```bash
python updater.py --id zCyDRywAAAAJ --output "C:\laragon\www\jhpttropika\jhpttropika34\plugins\generic\scholarCitationWidget\cache\citations.json"
```

**Flag tersedia:**
```
--id          Google Scholar User ID (wajib)
--output      Path ke file citations.json output
--no-selenium Nonaktifkan fallback Selenium
```

### Otomatisasi Update

#### Windows Task Scheduler

1. Buka **Task Scheduler** → **Create Basic Task**
2. Trigger: **Daily** (setiap hari)
3. Action: **Start a program**
   - Program: `python`
   - Arguments: `"C:\...\updater\updater.py" --id zCyDRywAAAAJ --output "C:\...\cache\citations.json"`
4. Simpan task

#### Linux/macOS Cron

```bash
# Edit crontab
crontab -e

# Jalankan setiap hari jam 02:00
0 2 * * * /usr/bin/python3 /var/www/html/ojs/plugins/generic/scholarCitationWidget/updater/updater.py --id zCyDRywAAAAJ --output /var/www/html/ojs/plugins/generic/scholarCitationWidget/cache/citations.json >> /var/log/scholar-updater.log 2>&1
```

---

## Format citations.json

```json
{
    "profile": {
        "name": "Nama Jurnal",
        "scholarId": "zCyDRywAAAAJ",
        "url": "https://scholar.google.com/citations?user=zCyDRywAAAAJ&hl=en"
    },
    "metrics": {
        "citations": 1258,
        "hindex": 19,
        "i10index": 31
    },
    "chart": [
        {"year": 2019, "citations": 98},
        {"year": 2020, "citations": 124},
        {"year": 2021, "citations": 145},
        {"year": 2022, "citations": 198},
        {"year": 2023, "citations": 230},
        {"year": 2024, "citations": 288},
        {"year": 2025, "citations": 175}
    ],
    "updated": "2026-07-20 18:00:00",
    "generator": "ScholarUpdater"
}
```

---

## Build ZIP (Untuk Developer)

```bash
python updater/build_zip.py
```

Output: `scholarCitationWidget-v1.0.0.zip`

---

## Keamanan

- ✅ HTML escaping pada semua output
- ✅ JSON validation sebelum render
- ✅ Scholar ID validation (regex)
- ✅ CSRF protection pada form settings
- ✅ Tidak ada `eval()`, `shell_exec()`, `exec()`
- ✅ Tidak ada eksekusi Python dari PHP
- ✅ Tidak ada scraping dari PHP

---

## Lisensi

Distributed under the [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).

Copyright (c) 2026 Bihikmi
