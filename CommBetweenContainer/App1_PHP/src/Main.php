<?php

echo '- Hi. I am: ' . `hostname`;
echo '- My IP is: ' . `hostname -i`;
echo '- Version info: ' . `php --version | head -1`;
echo '- ARG: ', PHP_EOL;
print_r($argv);
echo '- GET: ', PHP_EOL;
print_r($_GET);
echo '- POST: ', PHP_EOL;
print_R($_POST);
