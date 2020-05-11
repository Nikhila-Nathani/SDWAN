#!/usr/bin/env python3

import os
import json
import sys
import re 

def extract_subnet_dict():
    global subnet_dict
    with open("../Northbound/VM_and_subnet.json","r+") as f:
        subnet_dict=json.load(f)

def extract_network_dict():
    global network_dict
    with open("subnet_repository.json","r+") as f:
        network_dict=json.load(f)

def extract_network_dict():
    global subnet_file_dict
    with open("subnet_bridge_repository.json","r+") as f:
        subnet_file_dict=json.load(f)

def extract_nw_name(TID,vpc,nw):
    global subnet_dict
    global network_dict
    try: 
        return True,network_dict[str(TID)][str(vpc)][str(nw)]
    except:
        return False,None

def create_cont(vm_name,veth1,veth2,br):
    os.system('sudo ansible-playbook ../Cont_south_bound/create_container.yml --extra-vars \'{ "c_name": "'+vm_name+'" }\'')
    print("VM  Created")
    os.system('sudo ansible-playbook ../Cont_south_bound/create_veth_container.yml --extra-vars \'{ "veth1": "'+veth1+'" "veth2": "'+veth2+'" }\'')
    print("VM veths  Created")
    os.system('sudo ansible-playbook ../Cont_south_bound/create_veth_to_l2bridge_container.yml --extra-vars \'{ "veth": "'+veth1+'" "bridge": "'+br+'"  }\'')
    print("attach veth1 to bridge Created")
    os.system('sudo ansible-playbook ../Cont_south_bound/create_veth_to_container.yml --extra-vars \'{ "c_name": "'+vm_name+'" "veth": "'+veth2+'"  }\'')
    print("attach veth2 to VM  Created")
    

def main():
    global subnet_dict
    global network_dict
    global subnet_file_dict
    subnet_dict={}
    network_dict={}
    subnet_file_dict={}

    extract_subnet_dict()
    extract_network_dict()
    extract_subnet_file_dict()

    tenant_id=subnet_dict["TenantID"]
    if tenant_id in network_dict:
        for key in subnet_dict["VM"]:
            vpc=int(key["VPC"])
            nw_list=[]
            for nw in key["subnet"]:
                nw_exist,name=extract_nw_name(tenant_id,vpc,nw)
                if nw_exist:
                    nw_list.append(str(name))
            create_cont(nw_list,f"vm_{tenant_id}_{vpc}_{str(key['ID'])}",f"vethvm{tenant_id}{vpc}{str(key['ID'])0}",f"vethvm{tenant_id}{vpc}{str(key['ID'])1}",str(subnet_file_dict[tenant_id][nw]))
 









if __name__=="__main__":
    main()
