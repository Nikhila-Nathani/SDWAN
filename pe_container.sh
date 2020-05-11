sudo ip link add veth1 type veth peer name veth2
sudo ip link add veth3 type veth peer name veth4
sudo ip link add veth5 type veth peer name veth6
sudo ip link add veth7 type veth peer name veth8
sudo ip link add veth9 type veth peer name veth10
sudo ip link add veth11 type veth peer name veth12
sudo ip link add veth13 type veth peer name veth14
pe1=$1
bkpe1=$2
pe2=$3
bkpe2=$4
pe3=$5
pe4=$6
pe1id=$(sudo docker inspect --format  "{{.State.Pid}}" $pe1)
bkpe1id=$(sudo docker inspect --format  "{{.State.Pid}}" $bkpe1)
pe2id=$(sudo docker inspect --format  "{{.State.Pid}}" $pe2)
bkpe2id=$(sudo docker inspect --format  "{{.State.Pid}}" $bkpe2)
pe3id=$(sudo docker inspect --format  "{{.State.Pid}}" $pe3)
pe4id=$(sudo docker inspect --format  "{{.State.Pid}}" $pe4)
sudo ip link set netns $pe1id dev veth1
sudo ip link set netns $pe1id dev veth3
sudo ip link set netns $bkpe1id dev veth5
sudo ip link set netns $bkpe1id dev veth7
sudo ip link set netns $pe2id dev veth11
sudo ip link set netns $pe2id dev veth9
sudo ip link set netns $pe4id dev veth4
sudo ip link set netns $pe4id dev veth8
sudo ip link set netns $pe4id dev veth12
sudo ip link set netns $pe4id dev veth13
sudo ip link set netns $pe3id dev veth2
sudo ip link set netns $pe3id dev veth6
sudo ip link set netns $pe3id dev veth14
sudo ip link set netns $pe3id dev veth10
sudo  docker exec $pe1 ip link set dev veth1 up
sudo  docker exec $pe1 ip link set dev veth3 up
sudo  docker exec $bkpe1 ip link set dev veth5 up
sudo  docker exec $bkpe1 ip link set dev veth7 up
sudo  docker exec $pe2 ip link set dev veth11 up
sudo  docker exec $pe2 ip link set dev veth9 up
sudo  docker exec $pe4 ip link set dev veth4 up
sudo  docker exec $pe4 ip link set dev veth8 up
sudo  docker exec $pe4 ip link set dev veth12 up
sudo  docker exec $pe4 ip link set dev veth13 up
sudo  docker exec $pe3 ip link set dev veth2 up
sudo  docker exec $pe3 ip link set dev veth6 up
sudo  docker exec $pe3 ip link set dev veth14 up
sudo  docker exec $pe3 ip link set dev veth10 up
sudo  docker exec $pe1 ip tunnel add G1 mode gre local 192.168.140.2 remote 192.168.140.3
sudo  docker exec $pe1 ip link set dev G1 up
sudo  docker exec $pe1 ip route add 192.168.142.0/24 dev G1
sudo  docker exec $pe1 ip tunnel add G2 mode gre local 192.168.145.2 remote 192.168.145.3
sudo  docker exec $pe1 ip link set dev G2 up
sudo  docker exec $pe1 ip route add 192.168.147.0/24 dev G2
sudo  docker exec $bkpe1 ip tunnel add G3 mode gre local 192.168.141.2 remote 192.168.141.3
sudo  docker exec $bkpe1 ip link set dev G3 up
sudo  docker exec $bkpe1 ip route add 192.168.142.0/24 dev G3
sudo  docker exec $bkpe1 ip tunnel add G4 mode gre local 192.168.146.2 remote 192.168.146.3
sudo  docker exec $bkpe1 ip link set dev G4 up
