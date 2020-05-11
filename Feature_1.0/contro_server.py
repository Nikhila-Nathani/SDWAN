from flask import Flask
from flask import jsonify
from flask import request
import time
import threading
from random import randint
import logging

app = Flask(__name__)

pe_list = {}

pe_tr = {}


@app.route('/heartbeat', methods=['GET'])
def heartbeat():
    global pe_list
    pe_info = request.get_json()
    if pe_info['id'] not in pe_list:
        pe_list[pe_info['id']] = {}
    pe_list[pe_info['id']]['location'] = pe_info['location']
    pe_list[pe_info['id']]['usage'] = pe_info['usage']
    pe_list[pe_info['id']]['time'] = int(round(time.time() * 1000))
    pe_list[pe_info['id']]['health'] = 'good'
    # health[pe_info['id']] = {"time": int(round(time.time() * 1000)), "health": "good"}
    return jsonify(pe_list)


# @app.route('/heartbeat-tr', methods=['GET'])
# def heartbeat_tr():
#     global pe_health, health, pe_tr
#     pe_tr_info = request.get_json()
#     pe_tr[pe_tr_info['id']] = {'location': pe_tr_info['location'], 'usage': pe_tr_info['usage']}
#     #health[pe_tr_info['id']] = {"time": int(round(time.time() * 1000)), "health": "good"}
#     return jsonify(health)


# def change_transit():
#     global pe_list
#     while True:
#         if len(pe_list) :
#             value = randint(0, len(pe_list) - 1)
#             print(value, len(pe_list), list(pe_list.keys()))
#             for pe in pe_list:
#                 pe_list[pe]['transit'] = False
#
#             if pe_list[list(pe_list.keys())[value]]['health'] != 'Down':
#                 pe_list[list(pe_list.keys())[value]]['transit'] = True
#             else:
#                 for pe in pe_list:
#                     if pe_list[pe]['health'] != 'Down':
#                         pe_list[pe]['transit'] = True
#                         break
#             print(pe_list)
#         time.sleep(10)


def change_transit():
    global pe_list
    toggle = False
    while True:
        if len(pe_list):
            # value = randint(0, len(pe_list) - 1)
            # print(value, len(pe_list), list(pe_list.keys()))
            for pe in pe_list:
                pe_list[pe]['transit'] = False
            if toggle:
                if 'pe3' in pe_list:
                    pe_list['pe3']['transit'] = True
                elif 'pe4' in pe_list:
                    pe_list['pe4']['transit'] = True
            else:
                if 'pe4' in pe_list:
                    pe_list['pe4']['transit'] = True
                elif 'pe3' in pe_list:
                    pe_list['pe3']['transit'] = True
        time.sleep(20)
        toggle = not toggle


def healthCheck():
    global pe_list
    print("In health Check")
    while True:
        for cl in pe_list:
            if int(round(time.time() * 1000)) - pe_list[cl]["time"] > 60000:
                print(cl + " is down")
                pe_list[cl]["health"] = "Down"
        time.sleep(35)


healthThread = threading.Thread(target=healthCheck)
healthThread.start()

transitThread = threading.Thread(target=change_transit)
transitThread.start()

if __name__ == "__main__":
    app.run(host='127.0.0.1', port='5000')
    logging.basicConfig(filename='audit.log', level=logging.DEBUG, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')
    healthThread.join()
    transitThread.join()
