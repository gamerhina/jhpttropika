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
                
                if (!function_exists('shell_exec')) {
                    return new JSONMessage(false, 'Sync failed: shell_exec function is disabled on your live server. Please contact your hosting provider or use manual update.');
                }
                
                $pluginDir = $this->getPluginPath();
                $pythonScript = realpath($pluginDir . '/updater/updater.py');
                
                $jsonPath = !empty($customPath)
                    ? $customPath
                    : realpath($pluginDir . '/cache') . '/citations.json';
                    
                $cmd = "python " . escapeshellarg($pythonScript) . " --id " . escapeshellarg($scholarId) . " --output " . escapeshellarg($jsonPath) . " 2>&1";
                $output = (string) @shell_exec($cmd);
                
                // Fallback to python3 if python is not found
                if (empty(trim($output)) || stripos($output, 'not found') !== false || stripos($output, 'not recognized') !== false) {
                    $cmd3 = "python3 " . escapeshellarg($pythonScript) . " --id " . escapeshellarg($scholarId) . " --output " . escapeshellarg($jsonPath) . " 2>&1";
                    $output = (string) @shell_exec($cmd3) ?: $output;
                }
                
                if (strpos($output, 'Update complete') !== false) {
                    // Clear OJS caches so the updated sidebar is shown immediately
                    $templateMgr = \APP\template\TemplateManager::getManager($request);
                    $templateMgr->clearTemplateCache();
                    
                    $cacheManager = \PKP\cache\CacheManager::getManager();
                    $cacheManager->flush();
                    
                    return new JSONMessage(true, 'Data synchronized successfully!');
                } else {
                    return new JSONMessage(false, 'Sync failed: ' . ($output ?: 'Python command failed or is not available.'));
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
}

if (!PKP_STRICT_MODE) {
    class_alias(
        '\APP\plugins\blocks\scholarCitationWidget\ScholarCitationWidgetBlockPlugin',
        '\ScholarCitationWidgetBlockPlugin'
    );
}
