#!/bin/bash

sudo docker build -t boune/todolist:1.0.0 /vagrant/docker/todolist/
sudo docker tag -f boune/todolist:1.0.0 192.168.33.201:5000/todolist:1.0.0
sudo docker push 192.168.33.201:5000/todolist:1.0.0
sudo docker rmi boune/todolist:1.0.0