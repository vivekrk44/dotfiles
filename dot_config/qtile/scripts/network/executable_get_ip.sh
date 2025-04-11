#!/usr/bin/env bash
wlan_ip=$(ip addr show wlp0s20f3: | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
eth_ip=$(ip addr show eno0: | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
echo "📡:${wlan_ip:-None} | E🖧: ${eth_ip:-None}"
