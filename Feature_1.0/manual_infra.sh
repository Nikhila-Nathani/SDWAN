#!/bin/bash

sudo chmod +x crt_cont_brd_1.sh
./crt_cont_brd_1.sh

echo 'Containers, bridges created'

sudo chmod +x crt_data_nw_2.sh
./crt_data_nw_2.sh

echo 'Data network created'

sudo chmod +x crt_control_nw_3.sh
./crt_control_nw_3.sh

echo 'Control network created'

sudo chmod +x ip_control_nw_4.sh
./ip_control_nw_4.sh

echo 'IP assigned to control network'

sudo chmod +x ip_data_nw_5.sh
./ip_data_nw_5.sh

echo 'IP assigned to data network'

sudo chmod +x crt_gretunnel_ce.sh
./crt_gretunnel_ce.sh

echo 'CE gre tunnels created'

sudo chmod +x gre_transit_pe4.sh
./gre_transit_pe4.sh

echo 'PE gre tunnels created'
