<?php
require 'lib/pkp/includes/bootstrap.php';
$p = \PKP\plugins\PluginRegistry::getPlugin('blocks', 'google-scholar-citations');
if ($p) {
    echo "Plugin found!\n";
    $val = $p->getSetting(1, 'blockContent');
    echo "Type of blockContent: " . gettype($val) . "\n";
    print_r($val);
} else {
    echo "Plugin not found.\n";
}
