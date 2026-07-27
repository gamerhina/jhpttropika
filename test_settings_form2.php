<?php
$_SERVER['HTTP_HOST'] = 'jhpttropika34.test';
$_SERVER['REQUEST_URI'] = '/index.php/jhpttropika/$$$call$$$/grid/settings/plugins/settings-plugin-grid/manage?verb=settings&plugin=scholarCitationWidget&category=blocks';
$_SERVER['REQUEST_METHOD'] = 'GET';
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';

// Import required classes
import('lib.pkp.classes.plugins.PluginRegistry');
import('classes.core.Request');
import('classes.core.Application');
import('lib.pkp.classes.core.PKPPageRouter');

$request = Application::get()->getRequest();
$router = new PKPPageRouter();
$request->setRouter($router);
$context = clone DAORegistry::getDAO('JournalDAO')->getAll()->next();
$router->setApplication(Application::get());
$request->setContext($context);

$plugin = PluginRegistry::loadPlugin('blocks', 'scholarCitationWidget');
if (!$plugin) {
    echo "Plugin not found. Simulating plugin instance...\n";
    require_once 'plugins/blocks/scholarCitationWidget_ojs33/ScholarCitationWidgetBlockPlugin.inc.php';
    $plugin = new ScholarCitationWidgetBlockPlugin();
    $plugin->register('blocks', 'plugins/blocks/scholarCitationWidget_ojs33', $context->getId());
}

try {
    $response = $plugin->manage(array(), $request);
    echo "AJAX Response:\n";
    print_r($response);
} catch (Throwable $e) {
    echo "Fatal Error: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString();
}
