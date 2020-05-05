from opcua import Server
from random import randint
import time
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
id = s.getsockname()[0]
s.close()

server = Server()
url = "opc.tcp://"+id+":4840"

server.set_endpoint(url)

name = "Server Raspberry Pi opc_ua"
addspace = server.register_namespace(name)

node = server.get_objects_node()

Param = node.add_object(addspace, "parameters")

K_phi = Param.add_variable(addspace, "K_phi", 0)
K_phi_p = Param.add_variable(addspace, "K_phi_p", 0)
K_theta = Param.add_variable(addspace, "K_theta", 0)
K_theta_p = Param.add_variable(addspace, "K_theta_p", 0)
flag = Param.add_variable(addspace, "flag di modifica", False)

K_phi.set_writable()
K_phi_p.set_writable()
K_theta.set_writable()
K_theta_p.set_writable()
flag.set_writable()

server.start()
print("server started at{}".format(url))
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
        flag.set_value(False)
    else:
        K = [K1, K2, K3, K4]
        print(K)
        time.sleep(2)