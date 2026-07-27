<?php
/**
 * @file plugins/generic/scholarCitationWidget/classes/Cache.php
 *
 * Copyright (c) 2026 Bihikmi
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Cache
 * @brief Simple file-based cache manager for Scholar Citation Widget.
 *        Checks if citation JSON is fresh within the configured TTL window.
 *        Does NOT perform any web requests.
 */

namespace APP\plugins\blocks\scholarCitationWidget\classes;

class Cache
{
    /** @var string Absolute path to the JSON cache file */
    private string $cachePath;

    /** @var int Cache lifetime in hours */
    private int $ttlHours;

    /** @var int Derived TTL in seconds */
    private int $ttlSeconds;

    /**
     * @param string $cachePath Absolute path to the citations.json cache file
     * @param int    $ttlHours  Cache time-to-live in hours (default 24)
     */
    public function __construct(string $cachePath, int $ttlHours = 24)
    {
        $this->cachePath  = $cachePath;
        $this->ttlHours   = max(1, $ttlHours);
        $this->ttlSeconds = $this->ttlHours * 3600;
    }

    /**
     * Check whether the cache file exists and is still fresh.
     *
     * @return bool True when cache is present and within TTL
     */
    public function isFresh(): bool
    {
        if (!file_exists($this->cachePath)) {
            return false;
        }

        $mtime = @filemtime($this->cachePath);
        if ($mtime === false) {
            return false;
        }

        return (time() - $mtime) < $this->ttlSeconds;
    }

    /**
     * Return the age of the cache file in seconds.
     * Returns -1 if the file does not exist.
     *
     * @return int
     */
    public function getAgeSeconds(): int
    {
        if (!file_exists($this->cachePath)) {
            return -1;
        }

        $mtime = @filemtime($this->cachePath);
        return $mtime !== false ? (time() - $mtime) : -1;
    }

    /**
     * Return a human-readable age string (e.g. "3h 12m ago").
     *
     * @return string
     */
    public function getAgeFormatted(): string
    {
        $age = $this->getAgeSeconds();
        if ($age < 0) {
            return 'N/A';
        }

        $hours   = (int) floor($age / 3600);
        $minutes = (int) floor(($age % 3600) / 60);

        if ($hours > 0) {
            return "{$hours}h {$minutes}m ago";
        }

        return "{$minutes}m ago";
    }

    /**
     * Return the absolute path to the cache file.
     *
     * @return string
     */
    public function getCachePath(): string
    {
        return $this->cachePath;
    }

    /**
     * Return the configured TTL in hours.
     *
     * @return int
     */
    public function getTtlHours(): int
    {
        return $this->ttlHours;
    }

    /**
     * Check whether the cache directory is writable.
     * Useful to diagnose write permission issues.
     *
     * @return bool
     */
    public function isCacheDirectoryWritable(): bool
    {
        $dir = dirname($this->cachePath);
        return is_dir($dir) && is_writable($dir);
    }
}
