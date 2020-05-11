#!/bin/bash

# PE --> Transit PE - PE4
sudo docker exec T1PE1 ip link del gretun1
sudo docker exec T1PE1 ip tunnel add gretun1 mode gre local 192.168.145.2 remote 192.168.145.3
sudo docker exec T1PE1 ip link set gretun1 up

sudo docker exec T1PE1B ip link del gretun1
sudo docker exec T1PE1B ip tunnel add gretun1 mode gre local 192.168.146.2 remote 192.168.146.3
sudo docker exec T1PE1B ip link set gretun1 up

sudo docker exec T1PE2 ip link del gretun1
sudo docker exec T1PE2 ip tunnel add gretun1 mode gre local 192.168.147.2 remote 192.168.147.3
sudo docker exec T1PE2 ip link set gretun1 up

sudo docker exec T1PE3 ip link del gretun1
sudo docker exec T1PE3 ip tunnel add gretun1 mode gre local 192.168.143.2 remote 192.168.143.3
sudo docker exec T1PE3 ip link set gretun1 up

#T1PE1

sudo docker exec T1PE4 ip link del gretun1
sudo docker exec T1PE4 ip tunnel add gretun1 mode gre local 192.168.145.3 remote 192.168.145.2
sudo docker exec T1PE4 ip link set gretun1 up

sudo docker exec T1PE4 ip link del gretun2
sudo docker exec T1PE4 ip tunnel add gretun2 mode gre local 192.168.147.3 remote 192.168.147.2
sudo docker exec T1PE4 ip link set gretun2 up

sudo docker exec T1PE4 ip link del gretun3
sudo docker exec T1PE4 ip tunnel add gretun3 mode gre local 192.168.143.3 remote 192.168.143.2
sudo docker exec T1PE4 ip link set gretun3 up

# Routes

sudo docker exec T1PE1 ip route add 192.168.149.0/24 dev gretun1
sudo docker exec T1PE1 ip route add 192.168.150.0/24 dev gretun1

sudo docker exec T1PE2 ip route add 192.168.148.0/24 dev gretun1
sudo docker exec T1PE2 ip route add 192.168.150.0/24 dev gretun1

sudo docker exec T1PE3 ip route add 192.168.148.0/24 dev gretun1
sudo docker exec T1PE3 ip route add 192.168.149.0/24 dev gretun1

sudo docker exec T1PE4 ip route add 192.168.148.0/24 dev gretun1
sudo docker exec T1PE4 ip route add 192.168.149.0/24 dev gretun2
sudo docker exec T1PE4 ip route add 192.168.150.0/24 dev gretun3
