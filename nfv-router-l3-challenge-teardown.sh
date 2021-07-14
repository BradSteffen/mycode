#!/usr/bin/bash

sudo ip netns del mar
sudo ip netns del car
sudo ip netns del tar
sudo ip netns del par
sudo ip netns del router
sudo ovs-vsctl del-br ovs-earth

sudo iptables -P FORWARD DROP
sudo iptables -F FORWARD && sudo iptables -t nat -F

