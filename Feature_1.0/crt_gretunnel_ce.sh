#!/bin/bash

# GRE Tunnels

# CE

sudo docker exec T1CE1 ip tunnel add gretun1 mode gre local 192.168.148.3 remote 192.168.149.3
sudo docker exec T1CE1 ip tunnel add gretun2 mode gre local 192.168.148.3 remote 192.168.150.3
sudo docker exec T1CE1 ip link set gretun1 up
sudo docker exec T1CE1 ip link set gretun2 up

sudo docker exec T1CE2 ip tunnel add gretun1 mode gre local 192.168.149.3 remote 192.168.148.3
sudo docker exec T1CE2 ip tunnel add gretun2 mode gre local 192.168.149.3 remote 192.168.150.3
sudo docker exec T1CE2 ip link set gretun1 up
sudo docker exec T1CE2 ip link set gretun2 up

sudo docker exec T1CE3 ip tunnel add gretun1 mode gre local 192.168.150.3 remote 192.168.148.3
sudo docker exec T1CE3 ip tunnel add gretun2 mode gre local 192.168.150.3 remote 192.168.149.3
sudo docker exec T1CE3 ip link set gretun1 up
sudo docker exec T1CE3 ip link set gretun2 up

# Routes

sudo docker exec T1CE1 ip route add 1.1.2.0/24 dev gretun1
sudo docker exec T1CE1 ip route add 1.1.3.0/24 dev gretun2

sudo docker exec T1CE2 ip route add 1.1.1.0/24 dev gretun1
sudo docker exec T1CE2 ip route add 1.1.3.0/24 dev gretun2

sudo docker exec T1CE3 ip route add 1.1.1.0/24 dev gretun1
sudo docker exec T1CE3 ip route add 1.1.2.0/24 dev gretun2
