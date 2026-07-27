"""
output.py – Handles serialisation and writing of citations.json.

Responsibilities:
  - Build the canonical output dictionary.
  - Write atomically: write to a temp file, then rename.
  - Validate that the written file is valid JSON before finishing.
"""

import datetime
import json
import os
import tempfile
from pathlib import Path
from typing import Any

from config import JSON_INDENT, JSON_ENCODING
from logger import get_logger

log = get_logger(__name__)


def build_output(data: dict[str, Any]) -> dict[str, Any]:
    """
    Build the canonical citations.json structure from raw parsed data.

    Args:
        data: Dictionary with keys 'profile', 'metrics', 'chart'.

    Returns:
        The complete output dictionary matching the spec format.

    Raises:
        KeyError: If required keys are missing from `data`.
    """
    return {
        "profile": {
            "name":      data["profile"]["name"],
            "scholarId": data["profile"]["scholarId"],
            "url":       data["profile"]["url"],
        },
        "metrics": {
            "citations": int(data["metrics"]["citations"]),
            "hindex":    int(data["metrics"]["hindex"]),
            "i10index":  int(data["metrics"]["i10index"]),
        },
        "chart": [
            {"year": int(entry["year"]), "citations": int(entry["citations"])}
            for entry in (data.get("chart") or [])
        ],
        "updated":   datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "generator": "ScholarUpdater",
    }


def save_json(data: dict[str, Any], output_path: str | Path) -> None:
    """
    Serialise `data` to JSON and write it atomically to `output_path`.

    Uses a temporary file in the same directory to avoid partial writes.
    On success, the temp file is renamed to `output_path`.

    Args:
        data:        Dictionary to serialise.
        output_path: Destination file path (string or Path).

    Raises:
        OSError:       If the directory is not writable.
        ValueError:    If the serialised output fails JSON round-trip validation.
    """
    output_path = Path(output_path)
    output_dir  = output_path.parent

    # Ensure the directory exists
    output_dir.mkdir(parents=True, exist_ok=True)

    json_text = json.dumps(data, indent=JSON_INDENT, ensure_ascii=False)

    # Validate the JSON before writing
    try:
        json.loads(json_text)
    except json.JSONDecodeError as exc:
        raise ValueError(f"JSON round-trip validation failed: {exc}") from exc

    # Atomic write via temp file
    tmp_fd, tmp_path = tempfile.mkstemp(dir=str(output_dir), suffix=".tmp")
    try:
        with os.fdopen(tmp_fd, "w", encoding=JSON_ENCODING) as fh:
            fh.write(json_text)

        # Rename is atomic on POSIX; on Windows it replaces the target
        os.replace(tmp_path, str(output_path))

        log.info("citations.json written to: %s", output_path)
        log.info(
            "  citations=%d  h-index=%d  i10-index=%d",
            data.get("metrics", {}).get("citations", 0),
            data.get("metrics", {}).get("hindex", 0),
            data.get("metrics", {}).get("i10index", 0),
        )
    except Exception:
        # Clean up temp file on failure
        if os.path.exists(tmp_path):
            os.remove(tmp_path)
        raise


def verify_output(output_path: str | Path) -> bool:
    """
    Verify that the output file exists, is non-empty, and is valid JSON.

    Args:
        output_path: Path to citations.json.

    Returns:
        True if the file is valid, False otherwise.
    """
    output_path = Path(output_path)

    if not output_path.exists():
        log.error("Output file not found: %s", output_path)
        return False

    if output_path.stat().st_size == 0:
        log.error("Output file is empty: %s", output_path)
        return False

    try:
        with open(output_path, "r", encoding=JSON_ENCODING) as fh:
            json.load(fh)
        log.debug("Output file verified OK: %s", output_path)
        return True
    except json.JSONDecodeError as exc:
        log.error("Output file is not valid JSON: %s – %s", output_path, exc)
        return False
