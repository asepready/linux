<?php
$host = "localhost";
$user = "abcnet";
$pass = "123456";
$conn = mysql_connect($host, $user, $pass);
if (!$conn) {
die("koneksi gagal");
}
echo "koneksi sukses";
mysqli_close($conn);
?>