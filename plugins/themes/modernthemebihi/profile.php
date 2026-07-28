<?php
define('INDEX_FILE_LOCATION', dirname(dirname(dirname(dirname(__FILE__)))) . '/index.php');
require(dirname(dirname(dirname(dirname(__FILE__)))) . '/lib/pkp/includes/bootstrap.php');

$start = microtime(true);
$request = \APP\core\Application::get()->getRequest();
$journal = \APP\facades\Repo::journal()->get(1);
$request->setContext($journal);

// 1. Get current issue
$issue = \APP\facades\Repo::issue()->getCurrent($journal->getId(), true);
echo "Got issue in " . (microtime(true) - $start) . "s<br>";
$start = microtime(true);

// 2. Get submissions in issue
$submissions = \APP\facades\Repo::submission()
    ->getCollector()
    ->filterByContextIds([$journal->getId()])
    ->filterByIssueIds([$issue->getId()])
    ->filterByStatus([\APP\submission\Submission::STATUS_PUBLISHED])
    ->orderBy(\APP\submission\Collector::ORDERBY_SEQUENCE, \APP\submission\Collector::ORDER_DIR_ASC)
    ->getMany();

echo "Got submissions in " . (microtime(true) - $start) . "s<br>";
$start = microtime(true);

$userGroups = \APP\facades\Repo::userGroup()->getCollector()->filterByRoleIds([\PKP\security\Role::ROLE_ID_AUTHOR])->filterByContextIds([$journal->getId()])->getMany()->remember();
foreach ($submissions as $submission) {
    $publication = $submission->getCurrentPublication();
    
    $s2 = microtime(true);
    $publication->getAuthorString($userGroups);
    $t_author = microtime(true) - $s2;
    
    $s2 = microtime(true);
    $submission->getGalleys();
    $t_galleys = microtime(true) - $s2;
    
    $s2 = microtime(true);
    $publication->getLocalizedData('coverImage');
    $t_cover = microtime(true) - $s2;
    
    echo "Article " . $submission->getId() . " (Author: " . number_format($t_author, 4) . "s, Galleys: " . number_format($t_galleys, 4) . "s, Cover: " . number_format($t_cover, 4) . "s)<br>";
}
echo "Finished processing articles in " . (microtime(true) - $start) . "s<br>";
