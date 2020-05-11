import subprocess
import os
import threading
import requests
import time
import psutil
import logging


status = {'id': 'pe4',
          'usage': 'OK',
          'location': 'site4'}


pe_list = {}
rate_limit_list = set()


def backup_route(pe_temp, pe):
    print(pe)
    # TODO: 1. delete route to original pe, 2. add route to backup pe
    # TODO: Add IP addresses
    if pe == 'pe3':
        cmd = 'sudo chmod +x backup_pe1_pe3.sh'
        os.system(cmd)
        cmd = 'sudo ./backup_pe1_pe3.sh'
        os.system(cmd)
    elif pe == 'pe4':
        cmd = 'sudo chmod +x backup_pe1_pe4.sh'
        os.system(cmd)
        cmd = 'sudo ./backup_pe1_pe4.sh'
        os.system(cmd)


def change_transit(pe):
    if pe == 'pe3':
        cmd = 'sudo chmod +x gre_transit_pe3.sh'
        os.system(cmd)
        cmd = 'sudo ./gre_transit_pe3.sh'
        os.system(cmd)

    elif pe == 'pe4':
        cmd = 'sudo chmod +x gre_transit_pe4.sh'
        os.system(cmd)
        cmd = 'sudo ./gre_transit_pe4.sh'
        os.system(cmd)


def rate_limit(pe, usage, pe_temp):
    print(pe)
    if pe not in rate_limit_list:
        if usage == 'HIGH':
            print("change range limit for "+pe)
            # TODO: add an iptables rule to drop the traffic to PE1 or limit the rate
            if pe == 'pe3':
                cmd = 'sudo docker exec T1PE3 tc qdisc add dev t1'+pe_temp+' root tbf rate 256bit latency 10ms burst 100ms'
                os.system(cmd)
            elif pe == 'pe4':
                cmd = 'sudo docker exec T1PE4 tc qdisc add dev t1' + pe_temp + ' root tbf rate 256bit latency 10ms burst 100ms'
                os.system(cmd)

            rate_limit_list.add(pe)
    else:
        if usage == 'OK':
            print("Revert the changes")
            # TODO: delte an iptables rule to drop the traffic to PE1 or limit the rate
            if pe == 'pe3':
                cmd = 'sudo docker exec T1PE3 tc qdisc del dev t1'+pe_temp+' root tbf rate 256bit latency 10ms burst 100ms'
                os.system(cmd)
            elif pe == 'pe4':
                cmd = 'sudo docker exec T1PE4 tc qdisc del dev t1' + pe_temp + ' root tbf rate 256bit latency 10ms burst 100ms'
                os.system(cmd)
            rate_limit_list.remove(pe)


def cpu_usage():
    global status
    threshold = 4
    while True:
        cpu_usage = psutil.cpu_percent()
        if cpu_usage > threshold:
            status['usage'] = 'HIGH'
        else:
            status['usage'] = 'OK'
        time.sleep(30)


def heartbeat():
    global pe_list
    global status
    pe_tran = set()
    while True:
        response = requests.get("http://127.0.0.1:5000/heartbeat", json=status)
        pe_list = response.json()
        # print(pe_list)

        for pe in pe_list:
            if pe == status['id'] and 'transit' in pe_list[pe] and pe_list[pe]['transit']:
                print("I'm transit", pe)
                for pe_temp, pe in pe_list:
                    if pe_list[pe_temp]['health'] == 'Down':
                        backup_route(pe_temp, pe)
                    print(pe_list[pe_temp]['health'])
                    rate_limit(pe, pe_list[pe]['usage'], pe_temp)
                print(pe_list[pe]['usage'])
            else:
                if pe != status['id']:
                    if 'transit' in pe_list[pe] and pe_list[pe]['transit']:
                        if pe not in pe_tran:
                            pe_tran.clear()
                            change_transit(pe)
                            pe_tran.add(pe)

        time.sleep(30)


hbeat = threading.Thread(target=heartbeat)
hbeat.start()

usageT = threading.Thread(target=cpu_usage)
usageT.start()

logging.basicConfig(filename='audit_client.log', level=logging.DEBUG, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

hbeat.join()
usageT.join()
