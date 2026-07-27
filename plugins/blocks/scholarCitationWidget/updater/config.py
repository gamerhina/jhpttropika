"""
config.py – Configuration constants for ScholarUpdater.

Adjust the values here to customise updater behaviour
without modifying updater.py or parser.py.
"""

# ------------------------------------------------------------------ #
#  Request settings                                                    #
# ------------------------------------------------------------------ #

# HTTP request timeout in seconds for BeautifulSoup4 mode
REQUEST_TIMEOUT: int = 15

# Number of retry attempts before giving up (BS4 mode)
REQUEST_MAX_RETRIES: int = 3

# Delay between retries in seconds
REQUEST_RETRY_DELAY: float = 5.0

# User-Agent header sent to Google Scholar
USER_AGENT: str = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/124.0.0.0 Safari/537.36"
)

# Google Scholar base URL template (Python format string)
SCHOLAR_URL_TEMPLATE: str = (
    "https://scholar.google.com/citations?user={scholar_id}&hl=en&sortby=pubdate"
)

# ------------------------------------------------------------------ #
#  Selenium settings (fallback mode)                                   #
# ------------------------------------------------------------------ #

# Seconds to wait after page load before scraping (Selenium)
SELENIUM_WAIT_SECONDS: float = 4.0

# Chrome window size for headless mode
SELENIUM_WINDOW_SIZE: str = "1920,1080"

# ------------------------------------------------------------------ #
#  Output settings                                                     #
# ------------------------------------------------------------------ #

# Default output filename when --output flag is omitted
DEFAULT_OUTPUT_FILENAME: str = "citations.json"

# JSON indent level for the output file (use None for compact output)
JSON_INDENT: int = 4

# Encoding for the output JSON file
JSON_ENCODING: str = "utf-8"

# ------------------------------------------------------------------ #
#  Logging settings                                                    #
# ------------------------------------------------------------------ #

# Log file name (relative to the updater/ directory, or absolute path)
LOG_FILE: str = "updater.log"

# Maximum log file size in bytes before rotation (5 MB)
LOG_MAX_BYTES: int = 5_242_880

# Number of rotated backup log files to keep
LOG_BACKUP_COUNT: int = 3

# Log level: DEBUG | INFO | WARNING | ERROR | CRITICAL
LOG_LEVEL: str = "INFO"
