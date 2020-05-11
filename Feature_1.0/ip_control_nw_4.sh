#!/bin/bash

# Assign IP addresses to all interfaces

sudo docker exec T1C ip addr add 192.168.130.2/24 dev t1cbr
sudo docker exec T1PE1 ip addr add 192.168.130.3/24 dev t1cbr
sudo docker exec T1PE1B ip addr add 192.168.130.7/24 dev t1cbr
sudo docker exec T1PE2 ip addr add 192.168.130.4/24 dev t1cbr
sudo docker exec T1PE3 ip addr add 192.168.130.5/24 dev t1cbr
sudo docker exec T1PE4 ip addr add 192.168.130.6/24 dev t1cbr

