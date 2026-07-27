"""
updater.py – Main entry point for ScholarUpdater.

Usage:
    python updater.py --id YOUR_SCHOLAR_ID --output /path/to/citations.json

Example:
    python updater.py --id zCyDRywAAAAJ --output ../cache/citations.json

Behaviour:
  1. Try BeautifulSoup4 (fast, lightweight).
  2. If BS4 fails, fall back to Selenium (headless Chrome).
  3. Build the canonical output dict using output.build_output().
  4. Write atomically using output.save_json().
  5. Verify the written file is valid.
  6. Exit 0 on success, 1 on failure.
"""

import argparse
import sys
from pathlib import Path

from config import DEFAULT_OUTPUT_FILENAME
from logger import get_logger
from output import build_output, save_json, verify_output
from parser import parse_with_bs4, parse_with_selenium

log = get_logger("updater")


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Update Google Scholar Citation Widget JSON Data",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument(
        "--id",
        required=True,
        metavar="SCHOLAR_ID",
        help="Google Scholar User ID (e.g. zCyDRywAAAAJ)",
    )
    p.add_argument(
        "--output",
        default=DEFAULT_OUTPUT_FILENAME,
        metavar="FILE",
        help="Path to the output citations.json (default: ./citations.json)",
    )
    p.add_argument(
        "--no-selenium",
        action="store_true",
        help="Disable Selenium fallback (useful on headless servers without Chrome)",
    )
    return p.parse_args()


def run(scholar_id: str, output_path: str, use_selenium_fallback: bool = True) -> bool:
    """
    Perform the full update cycle.

    Returns:
        True on success, False on failure.
    """
    log.info("=" * 60)
    log.info("ScholarUpdater  –  Scholar ID: %s", scholar_id)
    log.info("Output path: %s", Path(output_path).resolve())

    raw_data = None

    # ── Attempt 1: BeautifulSoup4 ────────────────────────────────────
    log.info("Attempt 1: BeautifulSoup4 ...")
    try:
        raw_data = parse_with_bs4(scholar_id)
        log.info("BeautifulSoup4 succeeded.")
    except Exception as exc:
        log.warning("BeautifulSoup4 failed: %s", exc)

    # ── Attempt 2: Selenium fallback ─────────────────────────────────
    if raw_data is None and use_selenium_fallback:
        log.info("Attempt 2: Selenium (headless Chrome) ...")
        try:
            raw_data = parse_with_selenium(scholar_id)
            log.info("Selenium succeeded.")
        except Exception as exc:
            log.error("Selenium fallback also failed: %s", exc)

    if raw_data is None:
        log.error("All fetch attempts failed. citations.json was NOT updated.")
        return False

    # ── Build output structure ───────────────────────────────────────
    try:
        output_data = build_output(raw_data)
    except (KeyError, TypeError) as exc:
        log.error("Failed to build output structure: %s", exc)
        return False

    # ── Write to disk ────────────────────────────────────────────────
    try:
        save_json(output_data, output_path)
    except (OSError, ValueError) as exc:
        log.error("Failed to write citations.json: %s", exc)
        return False

    # ── Verify ───────────────────────────────────────────────────────
    if not verify_output(output_path):
        log.error("Output verification failed.")
        return False

    log.info("Update complete. citations.json is ready.")
    log.info("=" * 60)
    return True


def main() -> None:
    args = parse_args()

    success = run(
        scholar_id=args.id,
        output_path=args.output,
        use_selenium_fallback=not args.no_selenium,
    )

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
