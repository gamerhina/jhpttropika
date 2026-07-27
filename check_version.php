<?php
$m = new mysqli('localhost', 'root', '', 'jhpttropika34');
$r = $m->query('SELECT * FROM versions WHERE current=1');
while($row = $r->fetch_assoc()) { print_r($row); }
