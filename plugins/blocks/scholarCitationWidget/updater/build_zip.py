"""
build_zip.py – Build a ready-to-install ZIP package for Scholar Citation Widget.

Run from the plugin root (scholarCitationWidget/) directory:

    python updater/build_zip.py

Output:
    scholarCitationWidget-v1.0.0.zip  (placed in the plugin root directory)

The ZIP follows the OJS plugin ZIP convention:
    scholarCitationWidget/
        index.php
        version.xml
        ...all other plugin files...
"""

import os
import sys
import zipfile
from pathlib import Path

# ── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR  = Path(__file__).parent.resolve()       # updater/
PLUGIN_ROOT = SCRIPT_DIR.parent.resolve()           # scholarCitationWidget/
PLUGIN_NAME = "scholarCitationWidget"
OUTPUT_ZIP  = PLUGIN_ROOT / f"{PLUGIN_NAME}-v1.0.0.zip"

# Files and directories to EXCLUDE from the ZIP
EXCLUDE_PATTERNS = {
    "__pycache__",
    ".git",
    ".gitignore",
    ".DS_Store",
    "Thumbs.db",
    "*.pyc",
    "*.pyo",
    "updater.log",
    "build_zip.py",   # Don't include this script in the ZIP
    f"{PLUGIN_NAME}-v1.0.0.zip",
}


def should_exclude(rel_path: Path) -> bool:
    """Return True if the file/directory should be excluded from the ZIP."""
    parts = rel_path.parts
    name  = rel_path.name

    for pattern in EXCLUDE_PATTERNS:
        if "*" in pattern:
            # Glob-style pattern (e.g. *.pyc)
            import fnmatch
            if fnmatch.fnmatch(name, pattern):
                return True
        elif name == pattern or pattern in parts:
            return True

    return False


def build_zip() -> None:
    if not PLUGIN_ROOT.exists():
        print(f"ERROR: Plugin root not found: {PLUGIN_ROOT}", file=sys.stderr)
        sys.exit(1)

    print(f"Building ZIP package...")
    print(f"  Source : {PLUGIN_ROOT}")
    print(f"  Output : {OUTPUT_ZIP}")
    print()

    file_count = 0

    with zipfile.ZipFile(OUTPUT_ZIP, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for abs_path in sorted(PLUGIN_ROOT.rglob("*")):
            rel_path = abs_path.relative_to(PLUGIN_ROOT)

            # Skip directories (ZipFile handles them implicitly)
            if abs_path.is_dir():
                continue

            if should_exclude(rel_path):
                print(f"  SKIP   {rel_path}")
                continue

            # Inside the ZIP, prefix with the plugin folder name
            arc_name = Path(PLUGIN_NAME) / rel_path
            zf.write(abs_path, arc_name)
            print(f"  ADD    {arc_name}")
            file_count += 1

    size_kb = OUTPUT_ZIP.stat().st_size / 1024
    print()
    print(f"Done! {file_count} files packed -> {OUTPUT_ZIP.name} ({size_kb:.1f} KB)")
    print()
    print("Installation:")
    print("  1. In OJS: Settings > Website > Plugins > Upload a New Plugin")
    print(f"  2. Upload: {OUTPUT_ZIP.name}")
    print("  3. Enable the plugin and configure your Scholar ID.")


if __name__ == "__main__":
    build_zip()
