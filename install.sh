#!/bin/bash
#1. Install the necessary software------------------------------
sudo apt-get update -y
sudo apt-get install hostapd udhcpd -y
sudo apt-get install iptables -y
#sudo apt-get install zip unzip -y
sudo apt-get update -y
#2. Configure DHCP----------------------------------------------
x=tem.tem
touch $x
sudo rm -rf /etc/default/udhcpd
sudo mkdir /etc/default
sudo touch /etc/default/udhcpd
echo "start 10.0.0.2 " >>   $x
echo "end 10.0.0.254" >> $x
echo "interface wlan0" >> $x
echo "remaining yes" >> $x
echo "opt dns 8.8.8.8 4.2.2.2" >> $x
echo "opt subnet 255.255.255.0" >> $x
echo "opt router 10.0.0.1" >> $x
echo "opt lease 864000" >> $x
sudo mv  $x /etc/udhcpd.conf
touch $x
echo "# Comment the following line to enable" >> $x
echo "#DHCPD_ENABLED=\"no\"" >> $x
echo "# Options to pass to busybox' udhcpd." >> $x
echo "# -S    Log to syslog" >> $x
echo "# -f    run in foreground" >> $x
echo "DHCPD_OPTS=\"-S\"" >> $x
sudo mv $x  /etc/default/udhcpd

#Config /etc/wpa_supplicant/wpa_supplicant.conf
touch $x
sudo rm -rf /etc/wpa_supplicant/wpa_supplicant.conf
sudo mkdir /etc/wpa_supplicant
sudo touch /etc/wpa_supplicant/wpa_supplicant.conf
echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" >> $x
echo "update_config=1" >> $x
echo "country=US" >> $x
echo "network={" >> $x
echo "        ssid=\"thanhle\"" >> $x
echo "        psk=\"thanhle12345\"" >> $x
echo "        key_mgmt=WPA-PSK" >> $x
echo "}" >> $x
sudo mv $x /etc/wpa_supplicant/wpa_supplicant.conf

#3. Configure HostAPD------------------------------------------------
touch $x
echo "interface=wlan0" >> $x
echo "driver=nl80211" >> $x
echo "ssid=My_AP" >> $x
echo "hw_mode=g" >> $x
echo "channel=6" >> $x
echo "macaddr_acl=0" >> $x
echo "auth_algs=1" >> $x
echo "ignore_broadcast_ssid=0" >> $x
echo  "wpa=0" >> $x
echo "wpa_passphrase=My_Passphrase" >> $x
echo "wpa_key_mgmt=WPA-PSK" >> $x
echo "wpa_pairwise=TKIP" >> $x
echo "rsn_pairwise=CCMP" >> $x
sudo mv  $x  /etc/hostapd/hostapd.conf
#4. Configure NAT--------------------------------------------
touch $x
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> $x
sudo mv $x /etc/default/hostapd

touch $x
sudo sed -i "/net.ipv4.ip_forward=/d" /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo sh -c "echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

sudo cp ap.sh /usr/bin/ap
sudo cp sta.sh /usr/bin/sta
