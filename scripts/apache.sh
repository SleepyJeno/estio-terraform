#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo chmod 766 /var/www/html/index.html 
sudo cat <<EOT > /var/www/html/index.html
<h1>Hello</h1>
<p>Date and time right now: <span id="datetime"></span></p>
<script>
var dt = new Date();
document.getElementById("datetime").innerHTML =dt.toLocaleDateString() + ", " +  dt.toLocaleTimeString();
</script>
EOT
sudo systemctl start apache2