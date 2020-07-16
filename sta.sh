#!/bin/bash
w_if="$(iw dev | grep Interface | awk '{print $2}' | cut -d/ -f1)"
if [ -z  "${w_if}" ] ; then
    echo "Not found wireless interface in $(uname -a | awk '{print $2}' | cut -d/ -f1)"
    exit
fi
WLAN_IF="interface ${w_if}"
WLAN_IP="static ip_address=10.0.0.1"
if [ -z "$1" ] && [ -z "$2" ]
# No ssid, no pass
then
  echo "Connect using current information"
else
# have ssid, no pass
  if !([ -z "$1"  ]) && [ -z "$2" ] ; then
	echo "Connecting to Open SSID $1"
	a="\"$1\""
	b="NONE"
	sudo sed -i -e "s/\(ssid=\).*/\1$a/" /etc/wpa_supplicant/wpa_supplicant.conf
	sudo sed -i -e "s/\(key_mgmt=\).*/\1$b/" /etc/wpa_supplicant/wpa_supplicant.conf
  else
#have ssid. have pass
	echo "Connecting to ssid:$1, pass:$2"
	a="\"$1\""
	b="\"$2\""
	c="WPA-PSK"
	sudo sed -i -e "s/\(ssid=\).*/\1$a/" /etc/wpa_supplicant/wpa_supplicant.conf
	sudo sed -i -e "s/\(psk=\).*/\1$b/" /etc/wpa_supplicant/wpa_supplicant.conf
	sudo sed -i -e "s/\(key_mgmt=\).*/\1$c/" /etc/wpa_supplicant/wpa_supplicant.conf
  fi
fi
sudo iptables -t nat -F POSTROUTING
sudo iptables -F FORWARD

sudo sed -i "/${WLAN_IF}/d" /etc/dhcpcd.conf
sudo sed -i "/${WLAN_IP}/d" /etc/dhcpcd.conf

sudo service wpa_supplicant stop
sudo service hostapd stop
sudo service udhcpd stop
sudo service dhcpcd stop
sudo killall -9 wpa_supplicant
sudo killall -9 udhcpd

sudo ifconfig ${w_if} up
sudo ip addr flush dev ${w_if}
sudo service wpa_supplicant restart
sudo wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i ${w_if} &
sudo service dhcpcd start

sudo update-rc.d hostapd disable
sudo update-rc.d udhcpd disable
sudo update-rc.d dhcpcd enable
