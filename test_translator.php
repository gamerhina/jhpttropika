<?php
$_SERVER['HTTP_HOST'] = 'jhpttropika34.test';
$_SERVER['REQUEST_URI'] = '/index.php/jhpttropika/index';
$_SERVER['SERVER_NAME'] = 'jhpttropika34.test';
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';

echo "Locale: " . app()->getLocale() . "\n";
echo "Fallback: " . app('translator')->getFallback() . "\n";

$plugin = new APP\plugins\blocks\scholarCitationWidget\ScholarCitationWidgetBlockPlugin();
$plugin->register('blocks', 'plugins/blocks/scholarCitationWidget', 1);

// Force load the locale
$plugin->addLocaleData();

$translator = app('translator');
echo "Trans: " . $translator->get('plugins.blocks.scholarCitationWidget.displayName') . "\n";

// print where it looks for the po file
echo "Registered Paths in Translator:\n";
// The translator is PKP\i18n\translation\Translator
