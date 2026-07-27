<?php
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';
$request = Application::get()->getRequest();
$plugin = PluginRegistry::loadPlugin('blocks', 'scholarCitationWidget');
if (!$plugin) {
    // maybe try to instantiate directly for test
    require_once 'plugins/blocks/scholarCitationWidget_ojs33/ScholarCitationWidgetBlockPlugin.inc.php';
    $plugin = new ScholarCitationWidgetBlockPlugin();
    $plugin->register('blocks', 'plugins/blocks/scholarCitationWidget_ojs33', 1);
}
require_once 'plugins/blocks/scholarCitationWidget_ojs33/ScholarCitationWidgetSettingsForm.inc.php';
$form = new ScholarCitationWidgetSettingsForm($plugin);
$form->initData();
echo $form->fetch($request);
