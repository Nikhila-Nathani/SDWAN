#!bin/bash

# Control Path Network

# Create veth pairs > Add to devices > set them up

# brd - TC1

sudo ip link add t1cbr type veth peer name t1c
sudo ip link set dev t1cbr netns $t1c_pid name t1cbr up
sudo brctl addif t1cbr0 t1c
sudo docker exec T1C ip link set t1cbr up
sudo ip link set t1c up

echo "T1C done"

# brd - T1PE1

sudo ip link add t1cbr type veth peer name t1pe1
sudo ip link set dev t1cbr netns $t1pe1_pid name t1cbr up
sudo brctl addif t1cbr0 t1pe1
sudo docker exec T1PE1 ip link set t1cbr up
sudo ip link set t1pe1 up

echo "T1PE1 done"

# brd - T1PE1B

sudo ip link add t1cbr type veth peer name t1pe1b
sudo ip link set dev t1cbr netns $t1pe1b_pid name t1cbr up
sudo brctl addif t1cbr0 t1pe1b
sudo docker exec T1PE1B ip link set t1cbr up
sudo ip link set t1pe1b up

echo "T1PE1B done"

# brd - T1PE2

sudo ip link add t1cbr type veth peer name t1pe2
sudo ip link set dev t1cbr netns $t1pe2_pid name t1cbr up
sudo brctl addif t1cbr0 t1pe2
sudo docker exec T1PE2 ip link set t1cbr up
sudo ip link set t1pe2 up

echo "T1PE2 done"

# brd - T1PE3

sudo ip link add t1cbr type veth peer name t1pe3
sudo ip link set dev t1cbr netns $t1pe3_pid name t1cbr up
sudo brctl addif t1cbr0 t1pe3
sudo docker exec T1PE3 ip link set t1cbr up
sudo ip link set t1pe3 up

echo "T1PE3 done"

# brd - T1PE4

sudo ip link add t1cbr type veth peer name t1pe4
sudo ip link set dev t1cbr netns $t1pe4_pid name t1cbr up
sudo brctl addif t1cbr0 t1pe4
sudo docker exec T1PE4 ip link set t1cbr up
sudo ip link set t1pe4 up

echo "T1PE4 done"

