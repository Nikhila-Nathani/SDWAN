
All shell scripts and Python scripts are supposed to be in same folder.

Python scripts implement SD-WAN functionality along with features.

Steps to create the required infratructure:

1. sudo chmod +x manual_infra.sh
2. sudo ./manual_infra.sh

3. python3 contro_server.py
4. python3 pe1_client_all.py
5. python3 pe1b_client_all.py
6. python3 pe2_client_all.py
7. python3 pe3_client_all.py
8. python3 pe4_client_all.py

Feature 1. Traffic Rate Limiting

Takes into consideration CPU usage of the PE. 'HIGH' CPU usage can be emulated by changing value of variable 'threshold' in function cpu_usage in corresponding PE's python script before running the script.

When 'HIGH' usage is detected in a PE, Transit PE performs rate limiting on the traffic destined to the PE with 'HIGH' usage.

Rate limiting can be observed by pinging from a container to two other containers. (T1C1, T1C2, T1C3)


Feature 2. Availability

This feature is demonstrated by provoding backup for PE1.

All PEs are sending heartbeat messages to the controller, on loss of which a PE going down will be detected.
PE1 going down can be emulated by stopping execution of PE1's python script. This will lead to activation of backup T1PE1B, all traffic to T1CE1 will be routed through T1PE1B, instead of T1PE1.

Feature 3. Location Change Support

This feature is demonstarated by changing the transit PE after a fixed duartion. The Transit PE will change from PE4 to PE3 and vice versa. After change in transit PEs, routes and GRE tunnels will be added to route the traffic through new transit PE.




