#!/usr/bin/env bash
#Change these variables!
NIC_NAME="eth0"
CTROUTING_INT_NAME="podvlanif"
CTNET_IP_ADDRESS="192.168.0.254/32"
CTNET_IP_RANGE="192.168.0.64/24"
SLEEP_TIME="15" #seconds

sleep ${SLEEP_TIME} #Do not rush things if executing during boot. This line is not mandatory and can be removed.


ip link add ${CTROUTING_INT_NAME} link ${NIC_NAME} type macvlan mode bridge ; ip addr add ${CTNET_IP_ADDRESS} dev ${CTROUTING_INT_NAME} ; ip link set ${CTROUTING_INT_NAME} up
ip route add ${CTNET_IP_RANGE} dev ${CTROUTING_INT_NAME}