#!/bin/bash

# Create containers

sudo docker run --cap-add net_admin --name T1C -dit all_in_one
sudo docker run --cap-add net_admin --name T1PE1 -dit all_in_one
sudo docker run --cap-add net_admin --name T1PE1B -dit all_in_one
sudo docker run --cap-add net_admin --name T1PE2 -dit all_in_one
sudo docker run --cap-add net_admin --name T1PE3 -dit all_in_one
sudo docker run --cap-add net_admin --name T1PE4 -dit all_in_one

sudo docker run --cap-add net_admin --name T1CE1 -dit all_in_one
sudo docker run --cap-add net_admin --name T1CE2 -dit all_in_one
sudo docker run --cap-add net_admin --name T1CE3 -dit all_in_one

sudo docker run --cap-add net_admin --name T1C1 -dit all_in_one
sudo docker run --cap-add net_admin --name T1C2 -dit all_in_one
sudo docker run --cap-add net_admin --name T1C3 -dit all_in_one

# Create controller bridge

sudo brctl addbr t1cbr0
sudo ip link set t1cbr0 up

sudo brctl addbr t1bubr0
sudo ip link set t1bubr0 up
