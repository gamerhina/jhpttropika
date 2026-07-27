<?php
$_SERVER['HTTP_HOST'] = 'jhpttropika34.test';
$_SERVER['REQUEST_URI'] = '/index.php/jhpttropika/$$$call$$$/grid/settings/plugins/settings-plugin-grid/manage?verb=settings&plugin=scholarCitationWidget&category=blocks';
$_SERVER['REQUEST_METHOD'] = 'GET';
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';

import('lib.pkp.classes.plugins.PluginRegistry');
import('classes.template.TemplateManager');

$plugin = PluginRegistry::loadPlugin('blocks', 'scholarCitationWidget');
if (!$plugin) {
    require_once 'plugins/blocks/scholarCitationWidget_ojs33/ScholarCitationWidgetBlockPlugin.inc.php';
    $plugin = new ScholarCitationWidgetBlockPlugin();
    $plugin->register('blocks', 'plugins/blocks/scholarCitationWidget_ojs33', 1);
}

try {
    $request = Application::get()->getRequest();
    $templateMgr = TemplateManager::getManager($request);
    $html = $plugin->getContents($templateMgr, $request);
    echo "Contents rendered successfully:\n";
    echo substr($html, 0, 100) . "...\n";
} catch (Throwable $e) {
    echo "Fatal Error in getContents: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString();
}
