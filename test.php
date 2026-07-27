<?php
$_SERVER['HTTP_HOST'] = 'jhpttropika34.test';
$_SERVER['REQUEST_URI'] = '/index.php/jhpttropika/index';
$_SERVER['SERVER_NAME'] = 'jhpttropika34.test';
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';

echo "Current Locale: " . PKP\facades\Locale::getLocale() . "\n";

$plugin = new APP\plugins\blocks\scholarCitationWidget\ScholarCitationWidgetBlockPlugin();
$plugin->register('blocks', 'plugins/blocks/scholarCitationWidget', 1);

echo "Translation: " . __('plugins.blocks.scholarCitationWidget.displayName') . "\n";
