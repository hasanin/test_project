<!DOCTYPE html>
<html>
<body>

<?php
$servername = "database";
$username = "root";
$password = "password";
$dbname = "employees";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
     die("Connection failed: " . $conn->connect_error);
}

$sql = "select * from employees where gender like 'M' and birth_date like '1965-02-01' and hire_date >= '1990-01-01' order by first_name, last_name";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
     // output data of each row
     while($row = $result->fetch_assoc()) {
         echo "<br> emp_no: ". $row["emp_no"]. " - Firstname: ". $row["first_name"]. " - Lastname: " . $row["last_name"] . "<br>";
     }
} else {
     echo "0 results";
}

$conn->close();
?>

</body>
</html>
