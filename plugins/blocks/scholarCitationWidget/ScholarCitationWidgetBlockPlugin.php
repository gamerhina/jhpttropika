<?php
/**
 * @file plugins/blocks/scholarCitationWidget/ScholarCitationWidgetBlockPlugin.php
 *
 * Copyright (c) 2026 Bihikmi
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ScholarCitationWidgetBlockPlugin
 * @brief Scholar Citation Widget OJS Block Plugin main class.
 *
 * Appears as a native sidebar block in OJS Appearance setup.
 * Reads locally cached citations.json and renders a beautiful sidebar widget
 * with Chart.js-powered citation trend graph.
 */

namespace APP\plugins\blocks\scholarCitationWidget;

use APP\core\Application;
use APP\template\TemplateManager;
use APP\plugins\blocks\scholarCitationWidget\classes\Cache;
use APP\plugins\blocks\scholarCitationWidget\classes\JsonReader;
use APP\plugins\blocks\scholarCitationWidget\classes\Widget;
use PKP\core\JSONMessage;
use PKP\linkAction\LinkAction;
use PKP\linkAction\request\AjaxModal;
use PKP\plugins\BlockPlugin;

class ScholarCitationWidgetBlockPlugin extends BlockPlugin
{
    /**
     * @copydoc Plugin::register()
     */
    public function register($category, $path, $mainContextId = null)
    {
        $success = parent::register($category, $path, $mainContextId);
        if ($success) {
            $this->addLocaleData();
        }
        return $success;
    }

    /**
     * @copydoc Plugin::getName()
     */
    public function getName()
    {
        return 'scholarCitationWidget';
    }

    /**
     * @copydoc Plugin::getPluginPath()
     */
    public function getPluginPath()
    {
        return 'plugins/blocks/scholarCitationWidget';
    }

    /**
     * @copydoc Plugin::getDisplayName()
     */
    public function getDisplayName()
    {
        return __('plugins.block.scholarCitationWidget.displayName');
    }

    /**
     * @copydoc Plugin::getDescription()
     */
    public function getDescription()
    {
        return __('plugins.block.scholarCitationWidget.description');
    }

    /**
     * @copydoc BlockPlugin::getBlockContext()
     */
    public function getBlockContext()
    {
        return BlockPlugin::BLOCK_CONTEXT_SIDEBAR;
    }

    /**
     * @copydoc BlockPlugin::getHideManagement()
     */
    public function getHideManagement()
    {
        return false;
    }

    /**
     * @copydoc Plugin::getActions()
     */
    public function getActions($request, $verb)
    {
        $router = $request->getRouter();
        return array_merge(
            $this->getEnabled() ? [
                new LinkAction(
                    'settings',
                    new AjaxModal(
                        $router->url($request, null, null, 'manage', null, [
                            'verb'     => 'settings',
                            'category' => 'blocks',
                            'plugin'   => $this->getName(),
                        ]),
                        $this->getDisplayName(),
                        'modal_edit'
                    ),
                    __('manager.plugins.settings'),
                    'edit'
                ),
            ] : [],
            parent::getActions($request, $verb)
        );
    }

    /**
     * @copydoc Plugin::manage()
     */
    public function manage($args, $request)
    {
        switch ($request->getUserVar('verb')) {
            case 'sync':
                $scholarId = $request->getUserVar('scholarId');
                $customPath = $request->getUserVar('jsonPath');
                
                // Clean Scholar ID (remove everything after '&' in case user copied the URL params)
                if (strpos($scholarId, '&') !== false) {
                    $scholarId = explode('&', $scholarId)[0];
                }
                $scholarId = trim($scholarId);
                
                if (empty($scholarId)) {
                    return new JSONMessage(false, 'Scholar ID is required for sync.');
                }
                
                $jsonPath = !empty($customPath)
                    ? $customPath
                    : realpath($this->getPluginPath() . '/cache') . '/citations.json';
                    
                $data = $this->_scrapeScholar($scholarId);
                
                if ($data !== false) {
                    $jsonContent = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
                    if (file_put_contents($jsonPath, $jsonContent) !== false) {
                        // Clear OJS caches so the updated sidebar is shown immediately
                        $templateMgr = \APP\template\TemplateManager::getManager($request);
                        $templateMgr->clearTemplateCache();
                        
                        $cacheManager = \PKP\cache\CacheManager::getManager();
                        $cacheManager->flush();
                        
                        return new JSONMessage(true, 'Data synchronized successfully!');
                    } else {
                        return new JSONMessage(false, 'Sync failed: Cannot write to file ' . $jsonPath . '. Please check folder permissions.');
                    }
                } else {
                    return new JSONMessage(false, 'Sync failed: Could not fetch data from Google Scholar. Profile might be private or blocked by CAPTCHA.');
                }

            case 'settings':
                $context   = $request->getContext();
                $contextId = $context ? $context->getId() : \PKP\core\PKPApplication::CONTEXT_SITE;

                $form = new ScholarCitationWidgetSettingsForm($this, $contextId);

                if ($request->getUserVar('save')) {
                    $form->readInputData();
                    if ($form->validate()) {
                        $form->execute();
                        return new JSONMessage(true);
                    }
                } else {
                    $form->initData();
                }
                return new JSONMessage(true, $form->fetch($request));
        }
        return parent::manage($args, $request);
    }

    /**
     * Get the HTML contents of the sidebar block.
     *
     * @param TemplateManager $templateMgr
     * @param PKPRequest $request
     * @return string HTML contents
     */
    public function getContents($templateMgr, $request = null)
    {
        if (!$request) {
            $request = Application::get()->getRequest();
        }
        $context = $request->getContext();
        if (!$context) {
            return '';
        }

        $contextId = $context->getId();

        // --- Resolve JSON path ---------------------------------------
        $customPath = $this->getSetting($contextId, 'jsonFileLocation');
        $jsonPath   = !empty($customPath)
            ? $customPath
            : $this->getPluginPath() . '/cache/citations.json';

        // --- Cache freshness check ---
        $cacheHours = (int) ($this->getSetting($contextId, 'cacheHours') ?? 24);
        $cache      = new Cache($jsonPath, $cacheHours);

        if (!$cache->isFresh()) {
            error_log('[ScholarCitationWidget] Cache is stale (' . $cache->getAgeFormatted() . '). Re-run updater.py to refresh.');
        }

        // --- Ensure locale files are registered for translations ---
        $this->addLocaleData();

        // --- Read & validate JSON ------------------------------------
        $reader   = new JsonReader($jsonPath);
        $jsonData = $reader->read();

        // --- Build widget view-model ---------------------------------
        $assetPath = $request->getBaseUrl() . '/' . $this->getPluginPath();
        $widget    = new Widget(
            data:            $jsonData,
            themeColor:      (string) ($this->getSetting($contextId, 'themeColor')    ?? '#014401'),
            sidebarTitle:    (string) ($this->getSetting($contextId, 'sidebarTitle')  ?? 'Google Scholar'),
            showButton:      (bool)   ($this->getSetting($contextId, 'showButton')    ?? true),
            showGraph:       (bool)   ($this->getSetting($contextId, 'showGraph')     ?? true),
            pluginAssetPath: $assetPath
        );

        // --- Assign vars to Smarty & fetch template ------------------
        $templateMgr->assign($widget->getTemplateVars());

        return $templateMgr->fetch($this->getTemplateResource('sidebar.tpl'));
    }

    /**
     * Scrape Google Scholar profile data directly via PHP
     *
     * @param string $scholarId
     * @return array|false Returns the parsed array or false on failure
     */
    private function _scrapeScholar($scholarId)
    {
        $url = 'https://scholar.google.com/citations?user=' . urlencode($scholarId) . '&hl=en';
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36');
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        $html = curl_exec($ch);
        curl_close($ch);

        if (!$html) return false;

        $doc = new \DOMDocument();
        @$doc->loadHTML($html);
        $xpath = new \DOMXPath($doc);

        $nameNode = $xpath->query('//div[@id="gsc_prf_in"]');
        $name = $nameNode->length > 0 ? trim($nameNode->item(0)->textContent) : '';

        // If the name is empty, it means the page structure was not found (maybe blocked)
        if (empty($name)) return false;

        $metrics = ['citations' => 0, 'hindex' => 0, 'i10index' => 0];
        $statsNodes = $xpath->query('//td[@class="gsc_rsb_std"]');
        if ($statsNodes->length >= 6) {
            $metrics['citations'] = (int) $statsNodes->item(0)->textContent;
            $metrics['hindex'] = (int) $statsNodes->item(2)->textContent;
            $metrics['i10index'] = (int) $statsNodes->item(4)->textContent;
        }

        $chart = [];
        $yearsNodes = $xpath->query('//span[@class="gsc_g_t"]');
        $citesNodes = $xpath->query('//span[@class="gsc_g_al"]');
        for ($i = 0; $i < $yearsNodes->length; $i++) {
            $chart[] = [
                'year' => (int) trim($yearsNodes->item($i)->textContent),
                'citations' => (int) trim($citesNodes->item($i)->textContent)
            ];
        }

        return [
            'profile' => [
                'name' => $name,
                'scholarId' => $scholarId,
                'url' => $url
            ],
            'metrics' => $metrics,
            'chart' => $chart,
            'updated' => date('Y-m-d H:i:s'),
            'generator' => 'ScholarUpdater (PHP)'
        ];
    }
}

if (!PKP_STRICT_MODE) {
    class_alias(
        '\APP\plugins\blocks\scholarCitationWidget\ScholarCitationWidgetBlockPlugin',
        '\ScholarCitationWidgetBlockPlugin'
    );
}
