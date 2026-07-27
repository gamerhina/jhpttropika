"""
logger.py – Centralised logging setup for ScholarUpdater.

Usage:
    from logger import get_logger
    log = get_logger(__name__)
    log.info("Starting update...")
"""

import logging
import os
import sys
from logging.handlers import RotatingFileHandler
from pathlib import Path

from config import LOG_FILE, LOG_MAX_BYTES, LOG_BACKUP_COUNT, LOG_LEVEL

# Resolve the log file path relative to this script's directory
_UPDATER_DIR = Path(__file__).parent.resolve()
_LOG_PATH    = Path(LOG_FILE) if Path(LOG_FILE).is_absolute() else _UPDATER_DIR / LOG_FILE

# Map string log level to logging constant
_LEVEL_MAP = {
    "DEBUG":    logging.DEBUG,
    "INFO":     logging.INFO,
    "WARNING":  logging.WARNING,
    "ERROR":    logging.ERROR,
    "CRITICAL": logging.CRITICAL,
}

_NUMERIC_LEVEL = _LEVEL_MAP.get(LOG_LEVEL.upper(), logging.INFO)

# Shared formatter
_FORMATTER = logging.Formatter(
    fmt="%(asctime)s  %(levelname)-8s  %(name)s  %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)


def _build_root_logger() -> logging.Logger:
    """Configure the root logger once and return it."""
    root = logging.getLogger("ScholarUpdater")
    if root.handlers:
        # Already initialised – avoid duplicate handlers
        return root

    root.setLevel(_NUMERIC_LEVEL)

    # ── Console handler ──────────────────────────────────────────────
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(_NUMERIC_LEVEL)
    console_handler.setFormatter(_FORMATTER)
    root.addHandler(console_handler)

    # ── Rotating file handler ────────────────────────────────────────
    try:
        file_handler = RotatingFileHandler(
            filename=str(_LOG_PATH),
            maxBytes=LOG_MAX_BYTES,
            backupCount=LOG_BACKUP_COUNT,
            encoding="utf-8",
        )
        file_handler.setLevel(_NUMERIC_LEVEL)
        file_handler.setFormatter(_FORMATTER)
        root.addHandler(file_handler)
    except (OSError, PermissionError) as exc:
        root.warning("Cannot write to log file %s: %s", _LOG_PATH, exc)

    return root


# Initialise once on import
_ROOT_LOGGER = _build_root_logger()


def get_logger(name: str = "ScholarUpdater") -> logging.Logger:
    """
    Return a child logger under the ScholarUpdater namespace.

    Args:
        name: Usually __name__ of the calling module.

    Returns:
        logging.Logger instance.
    """
    if name == "ScholarUpdater" or not name:
        return _ROOT_LOGGER
    return _ROOT_LOGGER.getChild(name.replace(".", "_"))
