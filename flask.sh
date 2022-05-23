#!/bin/bash
sudo apt update
sudo git clone https://github.com/nathanforester/BirthDateAppFlask.git /home/ubuntu/BirthDateAppFlask
sudo cat <<EOF > /home/ubuntu/BirthDateAppFlask/requirements.txt 
Flask==2.0
Flask-Testing==0.8.0
Werkzeug==2.0
pytest==5.4.3
pytest-cov==2.10.0
requests==2.22.0
requests-mock==1.8.0
jinja2==3.0
itsdangerous==2.1.1
EOF
sudo chown -R ubuntu /home/ubuntu/BirthDateAppFlask/
sudo apt install python3-pip -y
sudo pip3 install -r /home/ubuntu/BirthDateAppFlask/requirements.txt
python3 /home/ubuntu/BirthDateAppFlask/app.py