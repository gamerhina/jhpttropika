<?php
$_SERVER['HTTP_HOST'] = 'jhpttropika34.test';
$_SERVER['REQUEST_URI'] = '/index.php/jhpttropika/$$$call$$$/grid/settings/plugins/settings-plugin-grid/manage?verb=settings&plugin=scholarCitationWidget&category=blocks';
$_SERVER['REQUEST_METHOD'] = 'GET';
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';

import('lib.pkp.classes.plugins.PluginRegistry');

$plugin = PluginRegistry::loadPlugin('blocks', 'scholarCitationWidget');
if (!$plugin) {
    require_once 'plugins/blocks/scholarCitationWidget_ojs33/ScholarCitationWidgetBlockPlugin.inc.php';
    $plugin = new ScholarCitationWidgetBlockPlugin();
    $plugin->register('blocks', 'plugins/blocks/scholarCitationWidget_ojs33', 1);
}

// Instantiate the form directly
require_once 'plugins/blocks/scholarCitationWidget_ojs33/ScholarCitationWidgetSettingsForm.inc.php';
$form = new ScholarCitationWidgetSettingsForm($plugin, 1);
$form->initData();

try {
    $request = Application::get()->getRequest();
    echo $form->fetch($request);
} catch (Throwable $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString();
}
