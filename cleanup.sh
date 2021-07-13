#!/bin/bash
sudo ip link del dev br0
sudo ip netns del peach
sudo ip netns del bowser

