#!/bin/bash

# Creates veth-pairs, adds to containers, sets them up (PEs, CEs)

t1c_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1C)
t1pe1_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1PE1)
t1pe1b_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1PE1B)
t1pe2_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1PE2)
t1pe3_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1PE3)
t1pe4_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1PE4)

t1ce1_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1CE1)
t1ce2_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1CE2)
t1ce3_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1CE3)

t1c1_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1C1)
t1c2_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1C2)
t1c3_pid=$(sudo docker inspect -f '{{.State.Pid}}' T1C3)

# Datapath Network

# T1C1 < - > T1CE1
sudo ip link add t1c1 type veth peer name t1ce1
sudo ip link set dev t1c1 netns $t1ce1_pid name t1c1
sudo ip link set dev t1ce1 netns $t1c1_pid name t1ce1
sudo docker exec T1CE1 ip link set t1c1 up
sudo docker exec T1C1 ip link set t1ce1 up

# T1C2 < - > T1CE2
sudo ip link add t1c2 type veth peer name t1ce2
sudo ip link set dev t1c2 netns $t1ce2_pid name t1c2
sudo ip link set dev t1ce2 netns $t1c2_pid name t1ce2
sudo docker exec T1CE2 ip link set t1c2 up
sudo docker exec T1C2 ip link set t1ce2 up

# T1C2 < - > T1CE2
sudo ip link add t1c3 type veth peer name t1ce3
sudo ip link set dev t1c3 netns $t1ce3_pid name t1c3
sudo ip link set dev t1ce3 netns $t1c3_pid name t1ce3
sudo docker exec T1CE3 ip link set t1c3 up
sudo docker exec T1C3 ip link set t1ce3 up

# PE1 < - > PE3

sudo ip link add t1pe3 type veth peer name t1pe1
sudo ip link set dev t1pe3 netns $t1pe1_pid name t1pe3
sudo ip link set dev t1pe1 netns $t1pe3_pid name t1pe1
sudo docker exec T1PE1 ip link set t1pe3 up
sudo docker exec T1PE3 ip link set t1pe1 up

# PE1 < - > PE4

sudo ip link add t1pe4 type veth peer name t1pe1
sudo ip link set dev t1pe4 netns $t1pe1_pid name t1pe4
sudo ip link set dev t1pe1 netns $t1pe4_pid name t1pe1
sudo docker exec T1PE1 ip link set t1pe4 up
sudo docker exec T1PE4 ip link set t1pe1 up

# PE1B < - > PE3

sudo ip link add t1pe3 type veth peer name t1pe1b
sudo ip link set dev t1pe3 netns $t1pe1b_pid name t1pe3
sudo ip link set dev t1pe1b netns $t1pe3_pid name t1pe1b
sudo docker exec T1PE1B ip link set t1pe3 up
sudo docker exec T1PE3 ip link set t1pe1b up

# PE1B < - > PE4

sudo ip link add t1pe4 type veth peer name t1pe1b
sudo ip link set dev t1pe4 netns $t1pe1b_pid name t1pe4
sudo ip link set dev t1pe1b netns $t1pe4_pid name t1pe1b
sudo docker exec T1PE1B ip link set t1pe4 up
sudo docker exec T1PE4 ip link set t1pe1b up

# PE2 < - > PE3

sudo ip link add t1pe3 type veth peer name t1pe2
sudo ip link set dev t1pe3 netns $t1pe2_pid name t1pe3
sudo ip link set dev t1pe2 netns $t1pe3_pid name t1pe2
sudo docker exec T1PE2 ip link set t1pe3 up
sudo docker exec T1PE3 ip link set t1pe2 up

# PE2 < - > PE4

sudo ip link add t1pe4 type veth peer name t1pe2
sudo ip link set dev t1pe4 netns $t1pe2_pid name t1pe4
sudo ip link set dev t1pe2 netns $t1pe4_pid name t1pe2
sudo docker exec T1PE2 ip link set t1pe4 up
sudo docker exec T1PE4 ip link set t1pe2 up

# PE3 < - > PE4

sudo ip link add t1pe3 type veth peer name t1pe4
sudo ip link set dev t1pe3 netns $t1pe4_pid name t1pe3
sudo ip link set dev t1pe4 netns $t1pe3_pid name t1pe4
sudo docker exec T1PE4 ip link set t1pe3 up
sudo docker exec T1PE3 ip link set t1pe4 up

###### PE < - > CE ######

# PE1 < - > CE1

sudo ip link add t1ce1 type veth peer name t1pe1
sudo ip link set dev t1ce1 netns $t1pe1_pid name t1ce1
sudo ip link set dev t1pe1 netns $t1ce1_pid name t1pe1
sudo docker exec T1PE1 ip link set t1ce1 up
sudo docker exec T1CE1 ip link set t1pe1 up

# PE2 < - > CE2

sudo ip link add t1ce2 type veth peer name t1pe2
sudo ip link set dev t1ce2 netns $t1pe2_pid name t1ce2
sudo ip link set dev t1pe2 netns $t1ce2_pid name t1pe2
sudo docker exec T1PE2 ip link set t1ce2 up
sudo docker exec T1CE2 ip link set t1pe2 up

# PE3 < - > CE3

sudo ip link add t1ce3 type veth peer name t1pe3
sudo ip link set dev t1ce3 netns $t1pe3_pid name t1ce3
sudo ip link set dev t1pe3 netns $t1ce3_pid name t1pe3
sudo docker exec T1PE3 ip link set t1ce3 up
sudo docker exec T1CE3 ip link set t1pe3 up

# PE1 < - > backup bridge

sudo ip link add t1bubr type veth peer name t1pe1b
sudo ip link set dev t1bubr netns $t1pe1_pid name t1bubr up
sudo brctl addif t1bubr0 t1pe1b
sudo docker exec T1PE1 ip link set t1bubr up
sudo ip link set t1pe1b up

# PE1B < - > backup bridge

sudo ip link add t1bubr type veth peer name t1pe1bb
sudo ip link set dev t1bubr netns $t1pe1b_pid name t1bubr up
sudo brctl addif t1bubr0 t1pe1bb
sudo docker exec T1PE1B ip link set t1bubr up
sudo ip link set t1pe1bb up

# CE1 < - > backup bridge

sudo ip link add t1bubr type veth peer name t1ce1b
sudo ip link set dev t1bubr netns $t1pe1_pid name t1bubr up
sudo brctl addif t1bubr0 t1ce1b
sudo docker exec T1CE1 ip link set t1bubr up
sudo ip link set t1ce1b up
