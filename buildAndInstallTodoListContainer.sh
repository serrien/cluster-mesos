#!/bin/bash

sudo docker build -t boune/todolist /vagrant/docker/todolist/
sudo docker tag -f boune/todolist 192.168.33.201:5000/todolist
sudo docker push 192.168.33.201:5000/todolist:latest
sudo docker rmi boune/todolist