sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo touch /home/ubuntu/.ssh/id_rsa && sudo chmod 600 /home/ubuntu/.ssh/id_rsa
sudo touch /home/ubuntu/.ssh/id_rsa.pub && sudo chmod 600 /home/ubuntu/.ssh/id_rsa.pub
sudo cat <<EOT > /home/ubuntu/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAIEAo/cz2KTpFicvoC/B8/2Y7UOdd4aikKT7/CjHXuJfTrb8YaUMjTqw
IhvC37QPNJDgrSHgS+0Zh1qovB2hi/VuDvnaUh3JMyP+dEWoCvzj4VmHStC8Ej9wz3H8eP
394UpbKfrCk7by6lw/WxgGH6pGDwf3bNg7nN1xU0Nn+dbPjvMAAAIQNE22OjRNtjoAAAAH
c3NoLXJzYQAAAIEAo/cz2KTpFicvoC/B8/2Y7UOdd4aikKT7/CjHXuJfTrb8YaUMjTqwIh
vC37QPNJDgrSHgS+0Zh1qovB2hi/VuDvnaUh3JMyP+dEWoCvzj4VmHStC8Ej9wz3H8eP39
4UpbKfrCk7by6lw/WxgGH6pGDwf3bNg7nN1xU0Nn+dbPjvMAAAADAQABAAAAgA5rF4kOf1
yuV3bLnE+bVk5O6tLu6O61Q19aKqYCXAUs/CaN//uPVJu7Ozi2ubuSnd87omCq2drYMwxP
wrvu+h186hq9nlb91/JNiC8zgZoIPnkmJ78RlRcZn35OqzC+5BA7unYTwuyPTtov/sUi8h
p70KPOaV19/Cwzpmj8pCrJAAAAQGW4EJeVwXww6CshEHNw8DKTvZnHqowRc7fHnOdfO03z
t5rg7YCPhndyH3ZOihP5ejZgGuL0R2xrko+Z1Alb+LoAAABBANpXkuf+VavJ5/Zi3ab5qr
V5LvU2J1pWAP1Gb446a2WwnOREQNoh5LpjhYseHtttYzrCc5i9oqe1jhWAIZdr1iUAAABB
AMA+wNJUXctovJMJFkARgJvyrvP1oJBAwaGBfVMW9ESrTP9GUSonaDy8zlxma5wEik/Bc1
wi36FhljB/034ESTcAAAAXdWJ1bnR1QGlwLTE3Mi0zMS00MS0xNzcBAgME
-----END OPENSSH PRIVATE KEY-----
EOT
sudo cat <<EOT > /home/ubuntu/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCj9zPYpOkWJy+gL8Hz/ZjtQ513hqKQpPv8KMde4l9OtvxhpQyNOrAiG8LftA80kOCtIeBL7RmHWqi8HaGL9W4O+dpSHckzI/50RagK/OPhWYdK0LwSP3DPcfx4/f3hSlsp+sKTtvLqXD9bGAYfqkYPB/ds2Duc3XFTQ2f51s+O8w== ubuntu@ip-172-31-41-177
EOT