#!/bin/bash
# TEARDOWN

# remove bridge
sudo ovs-vsctl del-br earth &> /dev/null
sudo ovs-vsctl del-br mars &> /dev/null

# remove VETH
sudo ip netns exec yoshi ip link delete yoshi2net &> /dev/null

# remove network namespaces
sudo ip netns del wario &> /dev/null
sudo ip netns del yoshi &> /dev/null

