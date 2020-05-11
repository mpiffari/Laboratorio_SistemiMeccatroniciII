######### LIBRARY IMPORT #######################
from opcua import Server
from random import randint
from datetime import datetime
import os
import time
import socket
#################################################

############ GET LOCAL MACHINE IP ###############
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
id = s.getsockname()[0]
s.close()
#################################################

########### SET SERVER INSTANCE #################
server = Server()
url = "opc.tcp://"+id+":4840"

server.set_endpoint(url)

name = "V.A.B. - Server Raspberry PI"
addspace = server.register_namespace(name)

node = server.get_objects_node()
Param = node.add_object(addspace, "Gain parameters")
#################################################

############ FILE READING #######################
fileName = "GainParameters.txt"
lineHeaders = ["K_phi ", "K_phi_p ", "K_theta ", "K_theta_p "]
initialValueGains = [0, 0, 0, 0]

if os.path.exists(fileName):
    print("Get initial values from file")
    file_object = open(fileName, "r+")
    lines = file_object.readlines()
    count = 0
    # Strips the newline character
    for line in lines:
        print(line.strip())
        values = line.split()
        if count <= 3:
            initialValueGains[count] = int(values[1])
        count = count + 1
    file_object.close()
else:
    print("Creating a new file and set parameters to zero")
    file_object = open(fileName, "w")
    for i, header in zip(range(4), lineHeaders):
        print(header + "0")
        file_object.write(header + "0\n")

    # current date and time
    now = datetime.now()
    timestamp = datetime.timestamp(now)
    dt_object = datetime.fromtimestamp(timestamp)
    file_object.write(str(dt_object))
    file_object.close()
#################################################

########## PARAMETERS INIT ######################
K_phi = Param.add_variable(addspace, "K_phi", initialValueGains[0])
K_phi_p = Param.add_variable(addspace, "K_phi_p", initialValueGains[1])
K_theta = Param.add_variable(addspace, "K_theta", initialValueGains[2])
K_theta_p = Param.add_variable(addspace, "K_theta_p", initialValueGains[3])
flag = Param.add_variable(addspace, "Submit modifiche", False)

K_phi.set_writable()
K_phi_p.set_writable()
K_theta.set_writable()
K_theta_p.set_writable()
flag.set_writable()
#################################################

server.start()

print("Server started at {}".format(url))

K1 = K_phi.get_value()
K2 = K_phi_p.get_value()
K3 = K_theta.get_value()
K4 = K_theta_p.get_value()

while True:
    if flag.get_value():
        K1 = K_phi.get_value()
        K2 = K_phi_p.get_value()
        K3 = K_theta.get_value()
        K4 = K_theta_p.get_value()

        gains = [K1, K2, K3, K4]
        file_object = open(fileName, "w")
        for header, gain in zip(lineHeaders, gains):
            file_object.write(header + str(gain) + "\n")

        # current date and time
        now = datetime.now()

        timestamp = datetime.timestamp(now)
        dt_object = datetime.fromtimestamp(timestamp)
        file_object.write(str(dt_object))
        file_object.close()

        flag.set_value(False)
    else:
        K = [K1, K2, K3, K4]
        print(K)
        time.sleep(2)
