<?php
$m = new mysqli('localhost', 'root', '', 'jhpttropika34');
$r = $m->query('DESCRIBE announcement_types');
while($row = $r->fetch_assoc()) { print_r($row); }
