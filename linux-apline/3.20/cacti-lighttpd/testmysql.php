<?php
//php -f testmysql.php
$dbname = 'cacti';
$dbhost = '192.168.20.4';
$dbuser = 'cactiuser';
$dbpass = 'iD0&t6raY768mQ6';

$link = mysqli_connect($dbhost, $dbuser, $dbpass) or die("Tidak dapat terhubung ke '$dbhost'");
mysqli_select_db($link, $dbname) or die("Tidak dapat membuka database '$dbname'");

$test_query = "SHOW TABLES FROM $dbname";
$result = mysqli_query($link, $test_query);

$tblCnt = 0;
while ($tbl = mysqli_fetch_array($result)) {
    $tblCnt++;
}

if (!$tblCnt) {
    echo "Tidak ada tabel<br />\n";
} else {
    echo "Ada $tblCnt tabel<br />\n";
}
?>