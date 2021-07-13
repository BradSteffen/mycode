#! /bin/bash
# teardown 19

sudo ip netns del peach
sudo ip netns del dhcp-peach
sudo ip netns del bowser
sudo ip netns del dhcp-bowser
sudo ovs-vsctl del-br donut-plains

