<?php
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://jhpttropika.fp.unila.ac.id/index.php/jhpttropika/login/signIn");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POST, 1);
// In OJS 3.4, login needs csrf token. Let's just fetch login page first to get CSRF token and cookie.
curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookies.txt');
curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookies.txt');
curl_setopt($ch, CURLOPT_URL, "https://jhpttropika.fp.unila.ac.id/index.php/jhpttropika/login");
curl_setopt($ch, CURLOPT_POST, 0);
$loginPage = curl_exec($ch);
preg_match('/name="csrfToken" value="([^"]+)"/', $loginPage, $matches);
$csrfToken = $matches[1] ?? '';

curl_setopt($ch, CURLOPT_URL, "https://jhpttropika.fp.unila.ac.id/index.php/jhpttropika/login/signIn");
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
    'csrfToken' => $csrfToken,
    'username' => 'jurnaladm',
    'password' => 'tropik4',
    'source' => ''
]));
$response = curl_exec($ch);

// Now fetch /submissions
curl_setopt($ch, CURLOPT_URL, "https://jhpttropika.fp.unila.ac.id/index.php/jhpttropika/submissions");
curl_setopt($ch, CURLOPT_POST, 0);
$dashboard = curl_exec($ch);
file_put_contents('dashboard.html', $dashboard);
echo "Fetched dashboard\n";
