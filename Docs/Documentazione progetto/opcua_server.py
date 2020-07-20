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
fileName_temp = "GainParametersToController.txt"
fileName_confirmed = "GainParametersConfirmed.txt"

lineHeaders = ["K_phi ", "K_phi_p ", "K_theta ", "K_theta_p "]
initialValueGains = [0, 0, 0, 0]

if os.path.exists(fileName_confirmed):
    print("Get initial values from file and create a temp one")
    file_object_def = open(fileName_confirmed, "r+")
    lines = file_object_def.readlines()
    count = 0
    # Strips the newline character
    for line in lines:
        print(line.strip())
        values = line.split()
        if count <= 3:
            initialValueGains[count] = int(values[1])
        else:
            timestamp = str(values[0]) + str(values[1])
        count = count + 1
    file_object_def.close()

    file_object_temp = open(fileName_temp, "w")
    for i, header in zip(initialValueGains, lineHeaders):
        print(header + str(i))
        file_object_temp.write(header + str(i) + "\n")

    # Time stamp from confirmed file
    file_object_temp.write(timestamp)
    file_object_temp.close()
else:
    print("Creating a new files and set parameters to zero")
    file_object_temp = open(fileName_temp, "w")
    file_object_def = open(fileName_confirmed, "w")

    for i, header in zip(range(4), lineHeaders):
        print(header + "0")
        file_object_temp.write(header + "0\n")
        file_object_def.write(header + "0\n")

    # current date and time
    now = datetime.now()
    timestamp = datetime.timestamp(now)
    dt_object = datetime.fromtimestamp(timestamp)
    file_object_temp.write(str(dt_object))
    file_object_def.write(str(dt_object))

    file_object_temp.close()
    file_object_def.close()
#################################################

########## PARAMETERS INIT ######################
K_phi = Param.add_variable(addspace, "K_phi", initialValueGains[0])
K_phi_p = Param.add_variable(addspace, "K_phi_p", initialValueGains[1])
K_theta = Param.add_variable(addspace, "K_theta", initialValueGains[2])
K_theta_p = Param.add_variable(addspace, "K_theta_p", initialValueGains[3])
submit_to_controller = Param.add_variable(addspace, "Submit change to controller", False)
submit_to_file = Param.add_variable(addspace, "Store definitively in file", False)
shut_down = Param.add_variable(addspace, "SHUT DOWN SERVER", False)

K_phi.set_writable()
K_phi_p.set_writable()
K_theta.set_writable()
K_theta_p.set_writable()
submit_to_controller.set_writable()
submit_to_file.set_writable()
shut_down.set_writable()
#################################################

server.start()

print("Server started at {}".format(url))

K1 = K_phi.get_value()
K2 = K_phi_p.get_value()
K3 = K_theta.get_value()
K4 = K_theta_p.get_value()

while True:
    save_on_temp_file = submit_to_controller.get_value()
    save_on_definitively_file = submit_to_file.get_value()
    exit = shut_down.get_value()

    if save_on_definitively_file:
        # Write on file that store gains considered stable
        K1 = K_phi.get_value()
        K2 = K_phi_p.get_value()
        K3 = K_theta.get_value()
        K4 = K_theta_p.get_value()

        gains = [K1, K2, K3, K4]
        file_object_conf = open(fileName_confirmed, "w")
        for header, gain in zip(lineHeaders, gains):
            file_object_conf.write(header + str(gain) + "\n")

        # current date and time
        now = datetime.now()

        timestamp = datetime.timestamp(now)
        dt_object = datetime.fromtimestamp(timestamp)
        file_object_conf.write(str(dt_object))
        file_object_conf.close()

        submit_to_file.set_value(False)
        print("Confirmed data")

    if save_on_temp_file:
        # Write on file that is read from controller on Raspberry
        K1 = K_phi.get_value()
        K2 = K_phi_p.get_value()
        K3 = K_theta.get_value()
        K4 = K_theta_p.get_value()

        gains = [K1, K2, K3, K4]
        file_object_temp = open(fileName_temp, "w")
        for header, gain in zip(lineHeaders, gains):
            file_object_temp.write(header + str(gain) + "\n")

        # current date and time
        now = datetime.now()

        timestamp = datetime.timestamp(now)
        dt_object = datetime.fromtimestamp(timestamp)
        file_object_temp.write(str(dt_object))
        file_object_temp.close()

        submit_to_controller.set_value(False)
        print("Submitted data to temp file that will be read from raspberry")

    if not save_on_temp_file and not save_on_definitively_file:
        # No change submitted
        K = [K1, K2, K3, K4]
        print(K)
        time.sleep(2)

    if exit:
        print("Shut down server...")
        break

if os.path.exists(fileName_temp):
    print("Removing temp file...")
    os.remove(fileName_temp)
else:
    print("The temp file does not exist")
print("Server stopped")