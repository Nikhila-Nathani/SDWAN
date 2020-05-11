#!/usr/bin/env python3

import os
import re
import sys
import json
import ipaddress



def extract_main_data():
    global data
    with open("../Northbound/tenant.json", "r+") as f :
        data=json.load(f)
    return data

def tenant_name():
    global data
    return data["TenantID"]

def num_iterations():
    global data
    return data["Number_of_VMs"]

def data_mac():
    global data
    return data["bridge_mac"]

def data_Network():
    global data
    return data["Network"]

def Internet_access():
    global data
    return data["Internet_access"]


def get_tenant_post_config():
    global last_tenant_config
    global last_db
    return last_db[tenant_name()]

def extract_last_db():
    global data
    global last_db

    try:
        last_db[tenant_name()]
    except:
        return False


def create_cmd(cmd):
    return "sudo ansible-playbook "+cmd

def deploy_namespace(ns_name):
    cmd=create_cmd(f" ../Cont_south_bound/create_container.yml --extra-vars 'c_name={ns_name}_ce'")
    os.system(cmd)
    print("VPC CE container created",file=sys.stderr)
    cmd=create_cmd(f" ../Cont_south_bound/create_container.yml --extra-vars 'c_name={ns_name}_pe'")
    os.system(cmd)
    print("VPC PE container created",file=sys.stderr)
    cmd=create_cmd(f" ../Cont_south_bound/create_container.yml --extra-vars 'c_name={ns_name}_bkpe'")
    os.system(cmd)
    print("VPC backup PE container created",file=sys.stderr)

    cmd=create_cmd(f" ../Cont_south_bound/create_L2_br.yml --extra-vars 'bridge={ns_name}_br'")
    os.system(cmd)
    print("External L2 br created", file=sys.stderr)
    return ns_name


def deploy_bridge(brl2,brl3,veth1,veth2,ns_name,start_ip,end_ip,gw,netmask):
    cmd=create_cmd(f"../Cont_south_bound/create_L2_br.yml --extra-vars 'bridge={brl2}'")
    os.system(cmd)
    print("L2 bridge created",file=sys.stderr)
    
    cmd= create_cmd(f"../Cont_south_bound/create_veth_container.yml --extra-vars 'veth1={veth1} veth2={veth2}'")
    os.system(cmd)
    print("veth pair created",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_l2bridge_container.yml --extra-vars 'bridge={brl2} veth={veth1}'")
    os.system(cmd)
    print("veth_attached to L2 bridge for container",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_container.yml --extra-vars 'c_name={ns_name}_ce veth={veth2}'")
    os.system(cmd)
    print("veth attached to container",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_routebr_container.yml --extra-vars 'c_name={ns_name}_ce veth2={veth2} routebr={brl3} start_ip={start_ip} end_ip={end_ip} gw={gw} netmask={netmask}'")
    os.system(cmd)
    print("Pulling container veth to L3 br",file=sys.stderr)


def attach_ce2pe(veth1,veth2,ns_name):
    cmd= create_cmd(f"../Cont_south_bound/create_veth_container.yml --extra-vars 'veth1={veth1} veth2={veth2}'")
    os.system(cmd)
    print("veth pair created",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_container.yml --extra-vars 'c_name={ns_name}_ce veth={veth1}'")
    os.system(cmd)
    print("veth attached to CE NS",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_container.yml --extra-vars 'c_name={ns_name}_pe veth={veth2}'")
    os.system(cmd)
    print("veth attached to PE NS",file=sys.stderr)

def attach_ce2l2(veth1,veth2,ns_name):
    cmd= create_cmd(f"../Cont_south_bound/create_veth_container.yml --extra-vars 'veth1={veth1} veth2={veth2}'")
    os.system(cmd)
    print("veth pair created",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_container.yml --extra-vars 'c_name={ns_name}_ce veth={veth1}'")
    os.system(cmd)
    print("veth attached to CE NS",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_l2bridge_container.yml --extra-vars 'bridge={ns_name}_br veth={veth2}'")
    os.system(cmd)
    print("veth attached to L2 ",file=sys.stderr)

    
    pass

def attach_l22pe(veth1,veth2,ns_name):

    cmd= create_cmd(f"../Cont_south_bound/create_veth_container.yml --extra-vars 'veth1={veth1} veth2={veth2}'")
    os.system(cmd)
    print("veth pair created",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_l2bridge_container.yml --extra-vars 'bridge={ns_name}_br veth={veth1}'")
    os.system(cmd)
    print("veth attached to L2 ",file=sys.stderr)

    cmd=create_cmd(f"../Cont_south_bound/attach_veth_to_container.yml --extra-vars 'c_name={ns_name}_pe veth={veth2}'")
    os.system(cmd)
    print("veth attached to PE NS",file=sys.stderr)

    pass
def attach_l22bkpe(veth1,veth2,ns_name):
    
    cmd= create_cmd(f"../Cont_south_bound/create_veth_container.yml --extra-vars 'veth1={veth1} veth2={veth2}'")
    os.system(cmd)
    print("veth pair created",file=sys.stderr)


    cmd=create_cmd(f"../Cont_south_bound/attach_veth_backup_container.yml --extra-vars 'c_name={ns_name}_bkpe veth1={veth1} veth2={veth2} bridge={ns_name}_br'")
    os.system(cmd)
    print("veth attached to Backup PE NS",file=sys.stderr)


def assign_outing_ip(veth,ns_name,ip):
    cmd=create_cmd(f"../Cont_south_bound/assigning_ip_container.yml --extra-vars 'c_name={ns_name} veth={veth} ip_addr={ip}'")
    os.system(cmd)
    print(f"Outing_ip to {ns_name} created",file=sys.stderr)

def assign_route(PE_ip,gre,dest_subnet,ns_name):
    cmd=create_cmd(f"../Cont_south_bound/gre_route_container.yml --extra-vars 'PE_ip={PE_ip} gre={gre} dest_subnet={dest_subnet} c_name={ns_name}'")
    os.system(cmd)
    print(f" Route added to {dest_subnet} from {ns_name}") 

def deploy_gre(ns_name,gre,ip1,ip2):
    cmd=create_cmd(f"../Cont_south_bound/create_gre_container.yml --extra-vars 'c_name={ns_name} gre={gre} src_ip={ip1} dest_ip={ip2}'")
    os.system(cmd)
    print("gre tunnel created")


def create_subnet_dict():
    global subnet_dict
    
    with open("subnet_repository.json","w+") as f:
        json.dump(subnet_dict,f,indent=4)


def build_topology():
    global data
    global last_db
    global subnet_dict

    namespace=[]
    TID=tenant_name()
    main_ip=f"1.0.0.0/16"
    main_ip_network=ipaddress.IPv4Network(main_ip)
    ns_dict={}
    hop_dict={}
    VPC_list=[]
    for key in data["VPC"]:
        namespace.append(deploy_namespace(str(TID)+"VPC"+str(key)))
        namespace.append(str(TID)+"VPC"+str(key))
        i=1
        subnet_dict[TID]={}
        subnet_dict[TID][key]={}
        VPC_list.append(key)    
        for value in data["VPC"][key]["subnet"]:
            subnet_ip=value
            brl2="brL2s"+str(i)+str(TID)+"VPC"+str(key)
            brl3="brL3s"+str(i)+str(TID)+"VPC"+str(key)
            veth1="vethbrs"+str(i)+str(TID)+"VPC"+str(key)
            veth2="vethnss"+str(i)+str(TID)+"VPC"+str(key)
            subnet_dict[TID][key][subnet_ip]=f"nw{brl2[5:]}"    
            ns_name=str(TID)+"VPC"+str(key)
            ip_addr=ipaddress.IPv4Network(subnet_ip)
            start_ip=ip_addr[2]
            end_ip=ip_addr[-2]
            gw=str(ip_addr[1])+"/"+str(ip_addr.prefixlen)
            netmask=str(ip_addr.netmask)
            deploy_bridge(brl2,brl3,veth1,veth2,ns_name,start_ip,end_ip,gw,netmask)
            i+=1
  
        attach_ce2l2("veth"+str(TID)+"VPC"+str(key)+"ce","veth"+str(TID)+"VPC"+str(key)+"l2c",namespace[-1])
        attach_l22pe("veth"+str(TID)+"VPC"+str(key)+"l2p","veth"+str(TID)+"VPC"+str(key)+"pe",namespace[-1])
        attach_l22bkpe("veth"+str(TID)+"VPC"+str(key)+"l2bk","veth"+str(TID)+"VPC"+str(key)+"bkpe",namespace[-1])
        ####################
        ns_dict[namespace[-1]+"_ce"]=str(main_ip_network[(256*int(TID))+2*int(key)+1])
        hop_dict[namespace[-1]+"_ce"]=str(main_ip_network[(256*int(TID))+2*int(key)+2])
        assign_outing_ip("veth"+str(TID)+"VPC"+str(key)+"ce",namespace[-1]+"_ce",str(main_ip_network[(256*int(TID))+2*int(key)+1])+"/"+str(main_ip_network.prefixlen))
        assign_outing_ip("veth"+str(TID)+"VPC"+str(key)+"pe",namespace[-1]+"_pe",str(main_ip_network[(256*int(TID))+2*int(key)+2])+"/"+str(main_ip_network.prefixlen))
        assign_outing_ip("veth"+str(TID)+"VPC"+str(key)+"bkpe",namespace[-1]+"_bkpe",str(main_ip_network[(256*int(TID))+2*int(key)+2])+"/"+str(main_ip_network.prefixlen))

    external_subnet_dict={}
    for i in VPC_list:
        for j in VPC_list:
            if i!=j:
                for k in data["VPC"][j]["subnet"]:
                    try:
                        external_subnet_dict[i].append(k)
                    except:
                        external_subnet_dict[i]=[k]

    ns_list=sorted(ns_dict)
    gre_dict={}
    for i in range(0,len(ns_list)):
        for j in range(i+1,len(ns_list)):
            deploy_gre(ns_list[i],f"gretun{i}{j}",str(ns_dict[ns_list[i]]),str(ns_dict[ns_list[j]]))
            if ns_list[i] not in gre_dict:
                gre_dict[ns_list[i]]=[{f"gretun{i}{j}":list(data["VPC"][str(j)]["subnet"].keys())}]
            else:
                gre_dict[ns_list[i]].append({f"gretun{i}{j}":list(data["VPC"][str(j)]["subnet"].keys())})
            if ns_list[j] not in gre_dict:
                gre_dict[ns_list[j]]=[{f"gretun{i}{j}":list(data["VPC"][str(i)]["subnet"].keys())}]
            else:
                gre_dict[ns_list[j]].append({f"gretun{i}{j}":list(data["VPC"][str(i)]["subnet"].keys())})


    for key in gre_dict.keys():
        for i in gre_dict[key]:
            for k in i.keys():
                for j in i[k]:
                    assign_route(hop_dict[key],k,j,key)


    

######Call for main function now ##########

def main():
    global data
    global last_db
    global last_tenant_config
    global subnet_dict
    data={}
    last_tenant_config={}
    subnet_dict={}

    data=extract_main_data()
#    last_db=extract_last_db()

#    if tenant_already_present():
#        last_tenant_config=get_tenant_post_config()
    build_topology()
    create_subnet_dict()














if __name__=="__main__":
    main()
    

                






