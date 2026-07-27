<?php
define('INDEX_FILE_LOCATION', 'index.php');
require 'lib/pkp/includes/bootstrap.php';

import('classes.core.Application');
import('lib.pkp.classes.statistics.StatisticsHelper');

$request = Application::get()->getRequest();
$context = $request->getContext();
if (!$context) {
    $contextDao = DAORegistry::getDAO('JournalDAO');
    $context = $contextDao->getAll()->next();
}

$filters = [
    'dateStart' => '2000-01-01',
    'dateEnd' => date('Y-m-d'),
    'contextIds' => [$context->getId()],
    'submissionIds' => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
];

try {
    $stats = Services::get('publicationStats')
        ->getQueryBuilder($filters)
        ->getSum(['submissionId'])
        ->get();
    
    echo "Stats result:\n";
    foreach ($stats as $row) {
        print_r($row);
    }
} catch (Throwable $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
