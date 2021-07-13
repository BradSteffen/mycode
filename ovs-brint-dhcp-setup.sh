#!/bin/bash

# create an OvS bridge called donut-plains
sudo ovs-vsctl add-br donut-plains

# create network namespaces
sudo ip netns add peach
sudo ip netns add bowser
sudo ip netns add dhcp-peach
sudo ip netns add dhcp-bowser

# create bridge internal interface
sudo ovs-vsctl add-port donut-plains peach -- set interface peach type=internal
sudo ovs-vsctl add-port donut-plains bowser -- set interface bowser type=internal
sudo ovs-vsctl add-port donut-plains dhcp-peach -- set interface dhcp-peach type=internal
sudo ovs-vsctl add-port donut-plains dhcp-bowser -- set interface dhcp-bowser type=internal

# plug the OvS bridge internals into the peach and bowser namespaces
sudo ip link set peach netns peach
sudo ip link set bowser netns bowser
sudo ip link set dhcp-peach netns dhcp-peach
sudo ip link set dhcp-bowser netns dhcp-bowser

# bring interface UP in peach
sudo ip netns exec peach ip link set dev peach up
sudo ip netns exec peach ip link set dev lo up

# bring interface UP in bowser
sudo ip netns exec bowser ip link set dev bowser up
sudo ip netns exec bowser ip link set dev lo up

# bring interface UP in peach-dhcp
sudo ip netns exec dhcp-peach ip link set dev dhcp-peach up
sudo ip netns exec dhcp-peach ip link set dev lo up

# bring interface UP in bowser-dhcp
sudo ip netns exec dhcp-bowser ip link set dev dhcp-bowser up
sudo ip netns exec dhcp-bowser ip link set dev lo up

# add VLANs
sudo ovs-vsctl set port peach tag=50
sudo ovs-vsctl set port bowser tag=150
sudo ovs-vsctl set port dhcp-peach tag=50
sudo ovs-vsctl set port dhcp-bowser tag=150

# add IPs to dhcp-bowser and dhcp-peach
sudo ip netns exec dhcp-peach ip addr add 172.16.2.50/24 dev dhcp-peach
sudo ip netns exec dhcp-bowser ip addr add 172.16.2.150/24 dev dhcp-bowser

# add DHCP servers to dhcp-peach and dhcp-bowser
sudo ip netns exec dhcp-peach dnsmasq --interface=dhcp-peach --dhcp-range=172.16.2.51,172.16.2.149,255.255.255.0
sudo ip netns exec dhcp-bowser dnsmasq --interface=dhcp-bowser --dhcp-range=172.16.2.151,172.16.2.249,255.255.255.0

# add DHCP client requests fo bowser and peach
sudo ip netns exec peach dhclient peach
sudo ip netns exec bowser dhclient bowser

