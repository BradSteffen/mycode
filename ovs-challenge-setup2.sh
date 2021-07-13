#! /bin/bash
# Lab 16 challenge setup

# Create ns wario and OVS earth
# create an OvS bridge called earth
sudo ovs-vsctl add-br earth
# create network namespaces
sudo ip netns add wario
# create veth interface
sudo ip link add wario2net type veth peer name net2wario
# plug in VETH to namespace
sudo ip link set wario2net netns wario
# connect net2wario into earth
sudo ovs-vsctl add-port earth net2wario
# bring interface UP in yoshi and wario
sudo ip netns exec wario ip link set dev wario2net up
sudo ip netns exec wario ip link set dev lo up
# add IP address to interface
sudo ip netns exec wario ip addr add 10.64.0.10/24 dev wario2net

# Create ns yoshi and OVS mars
# create an OvS bridge called mars
sudo ovs-vsctl add-br mars
# create network namespace
sudo ip netns add yoshi
# create veth interface
sudo ip link add yoshi2net type veth peer name net2yoshi
# plug in VETH to namespace
sudo ip link set yoshi2net netns yoshi
# connect net2yoshi into mars
sudo ovs-vsctl add-port mars net2yoshi
# bring interface UP in yoshi and wario
sudo ip netns exec yoshi ip link set dev yoshi2net up
sudo ip netns exec yoshi ip link set dev lo up
# add IP address to interface
sudo ip netns exec yoshi ip addr add 10.64.0.11/24 dev yoshi2net

# Create patch between earth and mars
sudo ovs-vsctl add-port earth moon -- set interface moon type=patch options:peer=phobos
sudo ovs-vsctl add-port mars phobos -- set interface phobos type=patch options:peer=moon

