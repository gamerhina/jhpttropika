<?php

/**
 * @file plugins/themes/default/ModernthemebihiThemePlugin.php
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ModernthemebihiThemePlugin
 * @ingroup plugins.themes.modernthemebihi
 *
 * @brief Default theme
 */

namespace APP\plugins\themes\modernthemebihi;

use APP\core\Application;
use PKP\config\Config;

class ModernthemebihiThemePlugin extends \PKP\plugins\ThemePlugin
{
    /**
     * Initialize the theme
     *
     * @return null
     */
    public function init()
    {
        $this->addLocaleData();

        // Register option for bootstrap themes
        $this->addOption('ModernthemebihiTheme', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.modernthemebihi.options.modernthemebihiTheme.label'),
            'description' => __('plugins.themes.modernthemebihi.options.modernthemebihiTheme.description'),
            'options' => [
                [
                    'value' => 'default',
                    'label' => __('plugins.themes.modernthemebihi.options.modernthemebihiTheme.default'),
                ],
            ],
        ]);
        $this->addOption('baseColor', 'FieldColor', [
            'label' => __('plugins.themes.modernthemebihi.options.baseColor.label'),
            'description' => __('plugins.themes.modernthemebihi.options.baseColor.description'),
            'default' => '#014401',
        ]);

        $this->addOption('editorialFooter', 'FieldRichTextarea', [
            'label' => __('plugins.themes.modernthemebihi.options.editorialFooter.label'),
            'description' => __('plugins.themes.modernthemebihi.options.editorialFooter.description'),
            'default' => '<p class="text-light mb-2">Editorial Office<br/>
				Plant Protection Building (G Building), 3rd Floor, Faculty of Agriculture, Universitas Lampung, Indonesia<br/>
				Jl. Prof. Sumantri Brojonegoro I, Bandar Lampung 35145 Indonesia<br/>
				Telp: +62-721-787029<br/>
                Email: jhpt.tropika@fp.unila.ac.id; jhpt.tropika@gmail.com</p>',
        ]);

        $this->addOption('sliderTransition', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.modernthemebihi.options.sliderTransition.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderTransition.description'),
            'options' => [
                ['value' => 'loop', 'label' => 'Slide (Loop)'],
                ['value' => 'fade', 'label' => 'Fade (Memudar)'],
            ],
            'default' => 'loop',
        ]);

        $this->addOption('sliderDuration', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderDuration.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderDuration.description'),
            'default' => '2500',
        ]);

        $this->addOption('sliderImage1', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderImage1.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderImage1.description'),
        ]);

        $this->addOption('sliderCaption1', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderCaption1.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderCaption1.description'),
        ]);

        $this->addOption('sliderLink1', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderLink1.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderLink1.description'),
        ]);

        $this->addOption('sliderImage2', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderImage2.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderImage2.description'),
        ]);

        $this->addOption('sliderCaption2', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderCaption2.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderCaption2.description'),
        ]);

        $this->addOption('sliderLink2', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderLink2.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderLink2.description'),
        ]);

        $this->addOption('sliderImage3', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderImage3.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderImage3.description'),
        ]);

        $this->addOption('sliderCaption3', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderCaption3.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderCaption3.description'),
        ]);

        $this->addOption('sliderLink3', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.sliderLink3.label'),
            'description' => __('plugins.themes.modernthemebihi.options.sliderLink3.description'),
        ]);

        $this->addOption('mainBgImage', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.mainBgImage.label'),
            'description' => __('plugins.themes.modernthemebihi.options.mainBgImage.description'),
        ]);

        $this->addOption('headerBgImage', 'FieldText', [
            'label' => __('plugins.themes.modernthemebihi.options.headerBgImage.label'),
            'description' => __('plugins.themes.modernthemebihi.options.headerBgImage.description'),
        ]);

        // Determine the path to the glyphicons font in Bootstrap
        $iconFontPath = Application::get()->getRequest()->getBaseUrl() . '/' . $this->getPluginPath() . '/bootstrap/fonts/';

        $this->addStyle('new-style', 'styles/new.style.css', array('contexts' => 'frontend'));
        $this->addStyle('backend-style-v2', 'styles/backend.style.css', array('contexts' => 'backend'));
        // $this->addStyle('new-style-unresponsive', 'styles/new.style.unresponsive.css', array('contexts' => 'frontend'));

        // Load jQuery from a CDN or, if CDNs are disabled, from a local copy.
        $min = Config::getVar('general', 'enable_minified') ? '.min' : '';
        $request = Application::get()->getRequest();
        // Use an empty `baseUrl` argument to prevent the theme from looking for
        // the files within the theme directory
        $jquery = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
        $jqueryUI = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';
        $this->addScript('jQuery', $jquery, array('baseUrl' => '', 'contexts' => 'frontend'));
        $this->addScript('jQueryUI', $jqueryUI, array('baseUrl' => '', 'contexts' => 'frontend'));
        $this->addScript('jQueryTagIt', $request->getBaseUrl() . '/lib/pkp/js/lib/jquery/plugins/jquery.tag-it.js', array('baseUrl' => '', 'contexts' => 'frontend'));

        // Load Bootstrap
        $this->addScript('bootstrap', 'bootstrap/js/bootstrap.min.js', array('contexts' => 'frontend'));

        // Add navigation menu areas for this theme
        $this->addMenuArea(array('primary', 'user'));

        // Hook to load authorUserGroups globally for templates without modifying core
        \PKP\plugins\Hook::add('TemplateManager::display', array($this, 'assignAuthorUserGroups'));
        \PKP\plugins\Hook::add('TemplateManager::display', array($this, 'assignThemeStyles'));

        // Hook for AJAX statistics
        \PKP\plugins\Hook::add('LoadHandler', array($this, 'handleAjaxRequest'));
        $this->addScript('stats-async', 'js/stats-async.js', array('contexts' => 'frontend'));
    }

    /**
     * Inject CSS variables into header
     */
    public function assignThemeStyles($hookName, $args)
    {
        $templateMgr = $args[0];
        $template = $args[1];

        // Only assign styles for frontend templates to avoid backend crashes
        if (strpos($template, 'frontend/') === false && strpos($template, 'core:') === false) {
            return false;
        }

        $baseColor = $this->getOption('baseColor');
        if (empty($baseColor)) {
            $baseColor = '#014401';
        }

        $templateMgr->assign('themeBaseColor', $baseColor);
        
        // Expose editorialFooter to templates
        $editorialFooter = $this->getOption('editorialFooter');
        $templateMgr->assign('editorialFooter', $editorialFooter);

        $templateMgr->assign('sliderTransition', $this->getOption('sliderTransition') ?: 'loop');
        $templateMgr->assign('sliderDuration', $this->getOption('sliderDuration') ?: '2500');
        $templateMgr->assign('sliderImage1', $this->getOption('sliderImage1'));
        $templateMgr->assign('sliderCaption1', $this->getOption('sliderCaption1'));
        $templateMgr->assign('sliderLink1', $this->getOption('sliderLink1'));
        
        $templateMgr->assign('sliderImage2', $this->getOption('sliderImage2'));
        $templateMgr->assign('sliderCaption2', $this->getOption('sliderCaption2'));
        $templateMgr->assign('sliderLink2', $this->getOption('sliderLink2'));
        
        $templateMgr->assign('sliderImage3', $this->getOption('sliderImage3'));
        $templateMgr->assign('sliderCaption3', $this->getOption('sliderCaption3'));
        $templateMgr->assign('sliderLink3', $this->getOption('sliderLink3'));
        $templateMgr->assign('mainBgImage', $this->getOption('mainBgImage'));
        $templateMgr->assign('headerBgImage', $this->getOption('headerBgImage'));

        return false;
    }

    /**
     * Fetch and assign authorUserGroups to the template manager
     */
    protected $_authorUserGroups = null;
    protected static $calledCount = 0;

    public function assignAuthorUserGroups($hookName, $args)
    {
        $templateMgr = $args[0];
        $template = $args[1];

        if (strpos($template, 'frontend/') === false && strpos($template, 'core:') === false) {
            return false;
        }

        $request = \APP\core\Application::get()->getRequest();
        $journal = $request->getJournal();

        if ($journal) {
            self::$calledCount++;
            file_put_contents('C:\laragon\tmp\ojs_perf_count.log', "assignAuthorUserGroups called: " . self::$calledCount . " times. This instance: " . spl_object_id($this) . "\n", FILE_APPEND);

            if ($this->_authorUserGroups === null) {
                file_put_contents('C:\laragon\tmp\ojs_perf_count.log', "Fetching from DB...\n", FILE_APPEND);
                $this->_authorUserGroups = \APP\facades\Repo::userGroup()->getCollector()
                    ->filterByRoleIds([\PKP\security\Role::ROLE_ID_AUTHOR])
                    ->filterByContextIds([$journal->getId()])
                    ->getMany()
                    ->remember();
            }
            $templateMgr->assign('authorUserGroups', $this->_authorUserGroups);
        }

        return false;
    }

    /**
     * Handle asynchronous statistics requests
     */
    public function handleAjaxRequest($hookName, $args)
    {
        $page = &$args[0];
        $op = &$args[1];

        if ($page === 'modernthemebihi' && $op === 'getStats') {
            $request = \APP\core\Application::get()->getRequest();
            
            $articleIds = $request->getUserVar('articleIds');
            $galleyIds = $request->getUserVar('galleyIds');
            
            if (!is_array($articleIds)) $articleIds = $articleIds ? explode(',', $articleIds) : [];
            if (!is_array($galleyIds)) $galleyIds = $galleyIds ? explode(',', $galleyIds) : [];
            
            $articleIds = array_filter(array_map('intval', $articleIds));
            $galleyIds = array_filter(array_map('intval', $galleyIds));
            
            $context = $request->getContext();
            $contextId = $context ? $context->getId() : 0;
            
            $results = [
                'articles' => [],
                'galleys' => [],
            ];
            
            try {
                if (!empty($articleIds)) {
                    foreach ($articleIds as $id) {
                        $cacheKey = 'views_a_' . $id;
                        $results['articles'][$id] = \Illuminate\Support\Facades\Cache::remember($cacheKey, 3600, function() use ($id, $contextId) {
                            $filters = [
                                'dateStart' => \APP\statistics\StatisticsHelper::STATISTICS_EARLIEST_DATE,
                                'dateEnd' => date('Y-m-d', strtotime('yesterday')),
                                'contextIds' => [$contextId],
                                'submissionIds' => [$id],
                                'assocTypes' => [\APP\core\Application::ASSOC_TYPE_SUBMISSION],
                            ];
                            $val = \APP\core\Services::get('publicationStats')->getQueryBuilder($filters)->getSum([])->value('metric');
                            return (int) $val;
                        });
                    }
                }
                
                if (!empty($galleyIds)) {
                    foreach ($galleyIds as $id) {
                        $cacheKey = 'views_g_' . $id;
                        $results['galleys'][$id] = \Illuminate\Support\Facades\Cache::remember($cacheKey, 3600, function() use ($id, $contextId) {
                            $filters = [
                                'dateStart' => \APP\statistics\StatisticsHelper::STATISTICS_EARLIEST_DATE,
                                'dateEnd' => date('Y-m-d', strtotime('yesterday')),
                                'contextIds' => [$contextId],
                                'submissionFileIds' => [$id],
                            ];
                            $val = \APP\core\Services::get('publicationStats')->getQueryBuilder($filters)->getSum([])->value('metric');
                            return (int) $val;
                        });
                    }
                }
            } catch (\Throwable $e) {
                // If query fails, silently return what we have (or empty)
            }
            
            header('Content-Type: application/json');
            echo json_encode($results);
            exit;
        }
        
        return false;
    }

    /**
     * Get the display name of this plugin
     * @return string
     */
    public function getDisplayName()
    {
        return __('plugins.themes.modernthemebihi.name');
    }

    /**
     * Get the description of this plugin
     * @return string
     */
    public function getDescription()
    {
        return __('plugins.themes.modernthemebihi.description');
    }
}

if (!PKP_STRICT_MODE) {
    class_alias('\APP\plugins\themes\modernthemebihi\ModernthemebihiThemePlugin', '\ModernthemebihiThemePlugin');
}
