<?php
/**
 * @file plugins/generic/scholarCitationWidget/ScholarCitationWidgetSettingsForm.php
 *
 * Copyright (c) 2026 Bihikmi
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ScholarCitationWidgetSettingsForm
 * @brief Form for journal managers to modify Scholar Citation Widget plugin settings
 */

namespace APP\plugins\blocks\scholarCitationWidget;

use APP\template\TemplateManager;
use PKP\form\Form;

class ScholarCitationWidgetSettingsForm extends Form
{
    /** @var int */
    public $_journalId;

    /** @var object */
    public $_plugin;

    /**
     * Constructor
     */
    public function __construct($plugin, $journalId)
    {
        $this->_journalId = $journalId;
        $this->_plugin = $plugin;

        parent::__construct($plugin->getTemplateResource('settingsForm.tpl'));

        $this->addCheck(new \PKP\form\validation\FormValidator($this, 'scholarId', 'required', 'plugins.block.scholarCitationWidget.settings.scholarIdRequired'));
        $this->addCheck(new \PKP\form\validation\FormValidatorPost($this));
        $this->addCheck(new \PKP\form\validation\FormValidatorCSRF($this));
    }

    /**
     * Initialize form data.
     */
    public function initData()
    {
        $this->_data = [
            'scholarId' => $this->_plugin->getSetting($this->_journalId, 'scholarId'),
            'cacheHours' => $this->_plugin->getSetting($this->_journalId, 'cacheHours') ?? 24,
            'jsonFileLocation' => $this->_plugin->getSetting($this->_journalId, 'jsonFileLocation'),
            'sidebarTitle' => $this->_plugin->getSetting($this->_journalId, 'sidebarTitle') ?? 'Google Scholar',
            'themeColor' => $this->_plugin->getSetting($this->_journalId, 'themeColor') ?? '#014401',
            'showButton' => $this->_plugin->getSetting($this->_journalId, 'showButton') ?? true,
            'showGraph' => $this->_plugin->getSetting($this->_journalId, 'showGraph') ?? true,
        ];
    }

    /**
     * Assign form data to user-submitted data.
     */
    public function readInputData()
    {
        $this->readUserVars([
            'scholarId',
            'cacheHours',
            'jsonFileLocation',
            'sidebarTitle',
            'themeColor',
            'showButton',
            'showGraph',
        ]);
    }

    /**
     * @copydoc Form::fetch()
     */
    public function fetch($request, $template = null, $display = false)
    {
        $templateMgr = TemplateManager::getManager($request);
        $templateMgr->assign('pluginName', $this->_plugin->getName());
        return parent::fetch($request, $template, $display);
    }

    /**
     * @copydoc Form::execute()
     */
    public function execute(...$functionArgs)
    {
        $this->_plugin->updateSetting($this->_journalId, 'scholarId', trim($this->getData('scholarId')), 'string');
        $this->_plugin->updateSetting($this->_journalId, 'cacheHours', (int)$this->getData('cacheHours'), 'int');
        $this->_plugin->updateSetting($this->_journalId, 'jsonFileLocation', trim($this->getData('jsonFileLocation')), 'string');
        $this->_plugin->updateSetting($this->_journalId, 'sidebarTitle', trim($this->getData('sidebarTitle')), 'string');
        $this->_plugin->updateSetting($this->_journalId, 'themeColor', trim($this->getData('themeColor')), 'string');
        $this->_plugin->updateSetting($this->_journalId, 'showButton', (bool)$this->getData('showButton'), 'bool');
        $this->_plugin->updateSetting($this->_journalId, 'showGraph', (bool)$this->getData('showGraph'), 'bool');

        parent::execute(...$functionArgs);
    }
}
