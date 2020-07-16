#!/bin/bash

sudo iptables -t nat -F POSTROUTING
sudo iptables -F FORWARD
sudo sed -i "/${WLAN_IF}/d" /etc/dhcpcd.conf
sudo sed -i "/${WLAN_IP}/d" /etc/dhcpcd.conf
sudo killall -9 udhcpd
sudo killall -9 hostapd
sudo killall -9 dhcpcd
sudo killall -9 wpa_supplicant

sudo ifconfig wlan0 up
sudo ip addr flush dev wlan0
sudo service wpa_supplicant restart
sudo service dhcpcd start
sudo update-rc.d hostapd disable
sudo update-rc.d udhcpd disable
sudo update-rc.d dhcpcd enable
sudo apt-get purge hostapd udhcpd -y
