#!/bin/bash

sudo docker pull tutum/hello-world
sudo docker tag -f tutum/hello-world 192.168.33.201:5000/hello-world
sudo docker push 192.168.33.201:5000/hello-world

sudo docker pull mongo:3.0.2
sudo docker tag -f mongo:3.0.2 192.168.33.201:5000/mongo:3.0.2
sudo docker push 192.168.33.201:5000/mongo:3.0.2

sudo docker build -t boune/nginx-hello /vagrant/docker/nginx-hello/
sudo docker tag -f boune/nginx-hello 192.168.33.201:5000/nginx-hello
sudo docker push 192.168.33.201:5000/nginx-hello

sudo docker build -t boune/nginx-todo /vagrant/docker/nginx-todo/
sudo docker tag -f boune/nginx-todo 192.168.33.201:5000/nginx-todo
sudo docker push 192.168.33.201:5000/nginx-todo


sudo docker build -t boune/todolist /vagrant/docker/todolist/
sudo docker tag -f boune/todolist 192.168.33.201:5000/todolist
sudo docker push 192.168.33.201:5000/todolist


sudo docker rmi tutum/hello-world
sudo docker rmi 192.168.33.201:5000/hello-world
sudo docker rmi mongo:3.0.2
sudo docker rmi 192.168.33.201:5000/mongo:3.0.2
sudo docker rmi boune/nginx-hello
sudo docker rmi 192.168.33.201:5000/nginx-hello
sudo docker rmi boune/nginx-todo
sudo docker rmi 192.168.33.201:5000/nginx-todo
sudo docker rmi boune/todolist
sudo docker rmi 192.168.33.201:5000/todolist
