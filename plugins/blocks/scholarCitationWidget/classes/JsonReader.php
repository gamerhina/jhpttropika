<?php
/**
 * @file plugins/generic/scholarCitationWidget/classes/JsonReader.php
 *
 * Copyright (c) 2026 Bihikmi
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class JsonReader
 * @brief Reads and validates citations.json from the local file system.
 *        NEVER scrapes Google Scholar. Only reads local JSON files.
 */

namespace APP\plugins\blocks\scholarCitationWidget\classes;

class JsonReader
{
    /** @var string Absolute path to the JSON file */
    private string $filePath;

    /** @var int Maximum file size in bytes (5 MB safety limit) */
    private const MAX_FILE_SIZE = 5242880;

    /** @var array Required top-level keys in the JSON */
    private const REQUIRED_KEYS = ['profile', 'metrics'];

    /**
     * @param string $filePath Absolute path to citations.json
     */
    public function __construct(string $filePath)
    {
        $this->filePath = $filePath;
    }

    /**
     * Read and return citation data from JSON file.
     *
     * Returns an array with 'error' key on failure,
     * or the full data array on success.
     *
     * @return array
     */
    public function read(): array
    {
        // 1. File existence check
        if (!file_exists($this->filePath)) {
            return $this->error('no_data');
        }

        // 2. File readability check
        if (!is_readable($this->filePath)) {
            return $this->error('unreadable');
        }

        // 3. File size sanity check
        if (filesize($this->filePath) > self::MAX_FILE_SIZE) {
            return $this->error('file_too_large');
        }

        // 4. Read file content
        $content = file_get_contents($this->filePath);
        if ($content === false) {
            return $this->error('read_failed');
        }

        // 5. Decode JSON
        $data = json_decode($content, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            return $this->error('invalid_json');
        }

        // 6. Validate required keys
        foreach (self::REQUIRED_KEYS as $key) {
            if (!isset($data[$key])) {
                return $this->error('invalid_json');
            }
        }

        // 7. Validate profile sub-keys
        if (
            !isset($data['profile']['name']) ||
            !isset($data['profile']['scholarId']) ||
            !isset($data['profile']['url'])
        ) {
            return $this->error('invalid_json');
        }

        // 8. Validate metrics sub-keys
        if (
            !isset($data['metrics']['citations']) ||
            !isset($data['metrics']['hindex']) ||
            !isset($data['metrics']['i10index'])
        ) {
            return $this->error('invalid_json');
        }

        // 9. Sanitize numeric values
        $data['metrics']['citations'] = (int) $data['metrics']['citations'];
        $data['metrics']['hindex']    = (int) $data['metrics']['hindex'];
        $data['metrics']['i10index']  = (int) $data['metrics']['i10index'];

        // 10. Sanitize profile strings
        $data['profile']['name']      = htmlspecialchars(strip_tags((string) $data['profile']['name']), ENT_QUOTES, 'UTF-8');
        $data['profile']['scholarId'] = preg_replace('/[^A-Za-z0-9_\-]/', '', (string) $data['profile']['scholarId']);
        $data['profile']['url']       = filter_var((string) $data['profile']['url'], FILTER_SANITIZE_URL);

        // 11. Sanitize chart data
        if (isset($data['chart']) && is_array($data['chart'])) {
            $cleanChart = [];
            foreach ($data['chart'] as $entry) {
                if (isset($entry['year']) && isset($entry['citations'])) {
                    $cleanChart[] = [
                        'year'      => (int) $entry['year'],
                        'citations' => (int) $entry['citations'],
                    ];
                }
            }
            $data['chart'] = $cleanChart;
        } else {
            $data['chart'] = [];
        }

        // 12. Sanitize updated field
        $data['updated'] = isset($data['updated'])
            ? htmlspecialchars(strip_tags((string) $data['updated']), ENT_QUOTES, 'UTF-8')
            : '';

        return $data;
    }

    /**
     * Get the absolute file path this reader is configured to use.
     *
     * @return string
     */
    public function getFilePath(): string
    {
        return $this->filePath;
    }

    /**
     * Check whether the JSON file exists and is non-empty.
     *
     * @return bool
     */
    public function exists(): bool
    {
        return file_exists($this->filePath) && filesize($this->filePath) > 0;
    }

    /**
     * Return a standardised error array.
     *
     * @param string $type  One of: no_data, unreadable, file_too_large, read_failed, invalid_json
     * @return array
     */
    private function error(string $type): array
    {
        $messages = [
            'no_data'       => 'plugins.generic.scholarCitationWidget.error.noData',
            'unreadable'    => 'plugins.generic.scholarCitationWidget.error.noData',
            'file_too_large'=> 'plugins.generic.scholarCitationWidget.error.invalidJson',
            'read_failed'   => 'plugins.generic.scholarCitationWidget.error.noData',
            'invalid_json'  => 'plugins.generic.scholarCitationWidget.error.invalidJson',
        ];

        return [
            'error'      => __($messages[$type] ?? 'plugins.generic.scholarCitationWidget.error.noData'),
            'error_type' => $type,
        ];
    }
}
