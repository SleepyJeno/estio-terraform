# update /etc/apache2/mods-enabled/dir.conf  to have .php first in list
# echo env variables on user_data stage for connection string 
# populate DB with dummy values 

// use the below as index.php content
<?php

$servername = "my-estio-db.cvcm0qa5mzrw.eu-west-2.rds.amazonaws.com:3306";
$username = "master";
$password = "foobarbaz";
$dbname = "estio_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
          die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM people";
$result = $conn->query($sql);

echo "The following people exist in the database:". "<br>";
if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
                    echo "id: " . $row["id"]. " - Name: " . $row["FirstName"]. " " . $row["LastName"]. "<br>";
                      }
} else {
          echo "0 results";
}
$conn->close();
?>



// potential user data. better use .bashrc and restart it 
user_data = <<-EOL
#!/bin/bash 
sudo apt update
sudo echo "USERNAME=${var.username}" >> /etc/environment
sudo echo "PASSWORD=${var.password}" >> /etc/environment
sudo echo "NAME=${var.dbname}" >> /etc/environment
sudo echo "ENDPOINT=${var.endpoint}" >> /etc/environment
git clone https://github.com/nathanforester/FlaskMovieDB2.git
sudo apt install mysql-server -y
. /home/ubuntu/FlaskMovieDB2/startup.sh
mysql -h $ENDPOINT -P $PORT -u master -pfoobarbaz
use estio_db
CREATE TABLE people(id SERIAL, FirstName varchar(55),LastName varchar(55));
INSERT INTO people(FirstName, LastName) VALUES ('Jack', 'Babber');
INSERT INTO people(FirstName, LastName) VALUES ('Jack', 'Babber');
INSERT INTO people(FirstName, LastName) VALUES ('Tester', 'Test');
EOL