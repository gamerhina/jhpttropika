<?php
$files = glob('plugins/*/*/version.xml');
foreach($files as $f) {
    if (@simplexml_load_file($f) === false) {
        echo "Bad XML: $f\n";
    }
}
