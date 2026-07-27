<?php
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';

import('classes.core.Application');
import('lib.pkp.classes.statistics.StatisticsHelper');

$request = Application::get()->getRequest();
$contextId = 1; // Assuming journal ID 1

$filters = [
    'dateStart' => '2000-01-01',
    'dateEnd' => date('Y-m-d'),
    'contextIds' => [$contextId],
    'submissionIds' => [1, 2, 3], // Test with IDs
];

try {
    $stats = Services::get('publicationStats')
        ->getQueryBuilder($filters)
        ->getSum([])
        ->value('metric');
    
    echo "Success. Total metric for array of submissions: " . $stats;
} catch (Throwable $e) {
    echo "Error: " . $e->getMessage();
}
