#! /bin/bash
# Commands to capture init environment state

ip link list > /tmp/ovs2-link-current
ip addr show > /tmp/ovs2-addr-current
ip route show > /tmp/ovs2-route-current
sudo ovs-vsctl show > /tmp/ovs2-show-current

diff /tmp/ovs2-link-init /tmp/ovs2-link-current
diff /tmp/ovs2-addr-init /tmp/ovs2-addr-current
diff /tmp/ovs2-route-init /tmp/ovs2-route-current
diff /tmp/ovs2-show-init /tmp/ovs2-show-current

