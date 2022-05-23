sudo apt update
cat <<EOT > /home/ubuntu/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCj9zPYpOkWJy+gL8Hz/ZjtQ513hqKQpPv8KMde4l9OtvxhpQyNOrAiG8LftA80kOCtIeBL7RmHWqi8HaGL9W4O+dpSHckzI/50RagK/OPhWYdK0LwSP3DPcfx4/f3hSlsp+sKTtvLqXD9bGAYfqkYPB/ds2Duc3XFTQ2f51s+O8w== ubuntu@ip-172-31-41-177
EOT
cat <<EOT >> /home/ubuntu/.ssh/authorized_keys 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCj9zPYpOkWJy+gL8Hz/ZjtQ513hqKQpPv8KMde4l9OtvxhpQyNOrAiG8LftA80kOCtIeBL7RmHWqi8HaGL9W4O+dpSHckzI/50RagK/OPhWYdK0LwSP3DPcfx4/f3hSlsp+sKTtvLqXD9bGAYfqkYPB/ds2Duc3XFTQ2f51s+O8w== ubuntu@ip-172-31-41-177
EOT