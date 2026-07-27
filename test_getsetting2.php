<?php
define('INDEX_FILE_LOCATION', __FILE__);
require 'lib/pkp/includes/bootstrap.php';
$p = new \APP\plugins\generic\customBlockManager\CustomBlockPlugin('google-scholar-citations', null);
$val = $p->getSetting(1, 'blockContent');
echo "Type: " . gettype($val) . "\n";
print_r($val);
echo "Current Locale: " . \PKP\facades\Locale::getLocale() . "\n";
