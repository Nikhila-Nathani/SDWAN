#!/bin/bash

sudo docker exec T1PE1 ip addr add 192.168.140.2/24 dev t1pe3
sudo docker exec T1PE1 ip addr add 192.168.145.2/24 dev t1pe4
sudo docker exec T1PE1 ip addr add 192.168.148.2/24 dev t1pe1b

sudo docker exec T1PE1B ip addr add 192.168.141.2/24 dev t1pe3
sudo docker exec T1PE1B ip addr add 192.168.146.2/24 dev t1pe4
sudo docker exec T1PE1B ip addr add 192.168.148.2/24 dev t1pe1bb

sudo docker exec T1PE2 ip addr add 192.168.142.2/24 dev t1pe3
sudo docker exec T1PE2 ip addr add 192.168.147.2/24 dev t1pe4
sudo docker exec T1PE2 ip addr add 192.168.149.2/24 dev t1ce2

sudo docker exec T1PE3 ip addr add 192.168.140.3/24 dev t1pe1
sudo docker exec T1PE3 ip addr add 192.168.141.3/24 dev t1pe1b
sudo docker exec T1PE3 ip addr add 192.168.142.3/24 dev t1pe2
sudo docker exec T1PE3 ip addr add 192.168.143.2/24 dev t1pe4
sudo docker exec T1PE3 ip addr add 192.168.150.2/24 dev t1ce3

sudo docker exec T1PE4 ip addr add 192.168.145.3/24 dev t1pe1
sudo docker exec T1PE4 ip addr add 192.168.146.3/24 dev t1pe1b
sudo docker exec T1PE4 ip addr add 192.168.147.3/24 dev t1pe2
sudo docker exec T1PE4 ip addr add 192.168.143.3/24 dev t1pe3

sudo docker exec T1CE1 ip addr add 192.168.148.3/24 dev t1pe1b
sudo docker exec T1CE2 ip addr add 192.168.149.3/24 dev t1pe2
sudo docker exec T1CE3 ip addr add 192.168.150.3/24 dev t1pe3

sudo docker exec T1C1 ip addr add 1.1.1.1/24 dev t1ce1
sudo docker exec T1CE1 ip addr add 1.1.1.2/24 dev t1c1

sudo docker exec T1C2 ip addr add 1.1.2.1/24 dev t1ce2
sudo docker exec T1CE2 ip addr add 1.1.2.2/24 dev t1c2

sudo docker exec T1C3 ip addr add 1.1.3.1/24 dev t1ce3
sudo docker exec T1CE3 ip addr add 1.1.3.2/24 dev t1c3

# Routes

sudo docker exec T1C1 ip route add 1.1.2.0/24 via 1.1.1.2
sudo docker exec T1C1 ip route add 1.1.3.0/24 via 1.1.1.2

sudo docker exec T1C2 ip route add 1.1.1.0/24 via 1.1.2.2
sudo docker exec T1C2 ip route add 1.1.3.0/24 via 1.1.2.2

sudo docker exec T1C1 ip route add 1.1.2.0/24 via 1.1.3.2
sudo docker exec T1C1 ip route add 1.1.1.0/24 via 1.1.3.2


