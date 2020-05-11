#!/bin/bash

# Activate Back-up PE1

sudo docker exec T1PE3 ip link del gretun1b
sudo docker exec T1PE3 ip tunnel add gretun1b mode gre local 192.168.141.3 remote 192.168.141.2
sudo docker exec T1PE3 ip link set gretun1b up

sudo docker exec T1PE3 ip route del 192.168.148.0/24 dev gretun1
sudo docker exec T1PE3 ip route add 192.168.148.0/24 dev gretun1b
