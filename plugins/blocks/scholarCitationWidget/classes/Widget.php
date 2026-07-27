<?php
/**
 * @file plugins/generic/scholarCitationWidget/classes/Widget.php
 *
 * Copyright (c) 2026 Bihikmi
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Widget
 * @brief Prepares and validates all data required to render the sidebar widget.
 *        Acts as the view-model between the plugin and the Smarty template.
 */

namespace APP\plugins\blocks\scholarCitationWidget\classes;

class Widget
{
    /** @var array Raw citation data returned by JsonReader */
    private array $data;

    /** @var string Hex colour for widget accent */
    private string $themeColor;

    /** @var string Sidebar block heading */
    private string $sidebarTitle;

    /** @var bool Whether to show the Google Scholar link button */
    private bool $showButton;

    /** @var bool Whether to show the chart */
    private bool $showGraph;

    /** @var string Base URL to the plugin assets directory */
    private string $pluginAssetPath;

    /**
     * @param array  $data            Validated data from JsonReader::read()
     * @param string $themeColor      Hex colour (e.g. '#014401')
     * @param string $sidebarTitle    Heading text for the sidebar block
     * @param bool   $showButton      Display the Google Scholar profile button
     * @param bool   $showGraph       Display the citation trend chart
     * @param string $pluginAssetPath URL path to plugin's public assets folder
     */
    public function __construct(
        array  $data,
        string $themeColor     = '#014401',
        string $sidebarTitle   = 'Google Scholar',
        bool   $showButton     = true,
        bool   $showGraph      = true,
        string $pluginAssetPath = ''
    ) {
        $this->data            = $data;
        $this->themeColor      = $this->sanitizeColor($themeColor);
        $this->sidebarTitle    = htmlspecialchars(strip_tags($sidebarTitle), ENT_QUOTES, 'UTF-8') ?: 'Google Scholar';
        $this->showButton      = $showButton;
        $this->showGraph       = $showGraph;
        $this->pluginAssetPath = rtrim($pluginAssetPath, '/');
    }

    /**
     * Return all template variables as a flat associative array
     * ready to be passed to Smarty's assign().
     *
     * @return array
     */
    public function getTemplateVars(): array
    {
        return [
            'scholarData'         => $this->data,
            'scholarThemeColor'   => $this->themeColor,
            'scholarSidebarTitle' => $this->sidebarTitle,
            'scholarShowButton'   => $this->showButton,
            'scholarShowGraph'    => $this->showGraph,
            'scholarPluginPath'   => $this->pluginAssetPath,
            'scholarHasError'     => $this->hasError(),
            'scholarHasChart'     => $this->hasChartData(),
        ];
    }

    /**
     * Check whether the data contains an error flag.
     *
     * @return bool
     */
    public function hasError(): bool
    {
        return isset($this->data['error']);
    }

    /**
     * Check whether chart data is present and non-empty.
     *
     * @return bool
     */
    public function hasChartData(): bool
    {
        return !$this->hasError()
            && $this->showGraph
            && isset($this->data['chart'])
            && is_array($this->data['chart'])
            && count($this->data['chart']) > 0;
    }

    /**
     * Return the total citation count, or 0 on error.
     *
     * @return int
     */
    public function getCitations(): int
    {
        return (int) ($this->data['metrics']['citations'] ?? 0);
    }

    /**
     * Return the h-index, or 0 on error.
     *
     * @return int
     */
    public function getHIndex(): int
    {
        return (int) ($this->data['metrics']['hindex'] ?? 0);
    }

    /**
     * Return the i10-index, or 0 on error.
     *
     * @return int
     */
    public function getI10Index(): int
    {
        return (int) ($this->data['metrics']['i10index'] ?? 0);
    }

    /**
     * Sanitize a hex colour string.
     * Falls back to the default journal green if the value is invalid.
     *
     * @param  string $color Raw input from settings
     * @return string Valid hex colour
     */
    private function sanitizeColor(string $color): string
    {
        $color = trim($color);

        // Ensure it starts with #
        if (!str_starts_with($color, '#')) {
            $color = '#' . $color;
        }

        // Accept #RGB or #RRGGBB
        if (preg_match('/^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$/', $color)) {
            return strtolower($color);
        }

        return '#014401'; // Default journal green
    }
}
