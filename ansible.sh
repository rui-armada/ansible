#!/bin/bash -xe

useradd ansible -G sudo -s /bin/bash -m
passwd -d ansible

cd /home/ansible/
mkdir .ssh
touch .ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/0/ia5rMqFsxC2vFeCKx+I7k87E/mvaYOGzojNlhhvg82k7avAexpl1ZfeHeqvvFrOYKE4W1jJU4ZvH8kqeLySpeDQEIMdZDdIoBvwLDZzWAYbA8G/ELt0Tgx42feiBRBLYykpvQZIPaadHVXPGbMtYWCUxu1oXT/h6dBz5B2pdb5PI2UUpmBL/+qGhvD2Wmn9PQcMR5bA8nmT0aW5KiZNFaq/cGhxVN2MN8W79oOVV6Xez7SzdzpZm5nS1GEmgBQgLbocXG2EYqnoCQuXxGktBat/plFZcKqCdeclKIJRYwjSWMSu81+06iuM7lYBesxjJxgg1Tbg2YIFCbWrj9qEpRZa6kxoASk2ACYhwVsGx5i5CT6dI4518ed83h5A7cFlUbIZ/xkRD685UhDNtMyg3Id1r3JJMky+qolNrQ8eWuS5chH4CdIWYhsbOAmXg02ZR+fkYYyNyk3lD8zNHJVOmYnY/5p2S0ViuGyvGD7aXjn5rTCzZ7ixWoM0R6xZO0=" > .ssh/authorized_keys

chown ansible:ansible .ssh -R
chmod 700 .ssh
chmod 644 .ssh/authorized_keys

touch /etc/sudoers.d/ansible
echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible