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

podman network create -d macvlan \
  --subnet 172.16.0.0/24 \
  --gateway 172.16.0.1 \
  --ip-range 172.16.0.64/26 \
  --interface eth0 \
  vlan

podman pod create \
  --name windows-pod \
  --network macvlan \
  --ip 172.16.0.2 \
  --subnet 172.16.0.0/24 \
  --gateway 172.16.0.1 \
  --hostname windows-10 \
  --publish 3389:3389/tcp \
  --publish 3389:3389/udp

podman run -d \
  --pod windows-pod \
  --name windows-container \
  --hostname windows-10 \
  --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --cap-add=NET_ADMIN \
  --device /dev/kvm \
  --device /dev/net/tun \
  --device /dev/kfd \
  --device /dev/dri \
  --env USERNAME="sysadmin" \
  --env PASSWORD="admin" \
  --env VERSION="10" \
  --env REGION="en-US" \
  --env KEYBOARD="en-US" \
  --env RAM="8G" \
  --env CPU="4" \
  --env DISK="64G" \
  --env GPU="true" \
  --volume ./data/win:/storage:z \
  --stop-timeout 120 \
  --restart unless-stopped \
  dockurr/windows