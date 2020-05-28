#! /bin/bash
if [ -z "$1" ]
then
  echo "No Input Name, select default name:ThanhLe_handsome"
  name="thanhle_me"
  sudo sed -i -e "s/\(ssid=\).*/\1$name/" /etc/hostapd/hostapd.conf

else
  sudo sed -i -e "s/\(ssid=\).*/\1$1/" /etc/hostapd/hostapd.conf
fi
if [ -z  "$2" ]
then
  echo "No Pass Hotspot"
  x=0
  sudo sed -i -e "s/\(wpa=\).*/\1$x/" /etc/hostapd/hostapd.conf
else
  x=2
  sudo sed -i -e "s/\(wpa=\).*/\1$x/" /etc/hostapd/hostapd.conf
  sudo sed -i -e "s/\(wpa_passphrase=\).*/\1$2/" /etc/hostapd/hostapd.conf
fi
dd="0"
sudo sed -i -e "s/\(ignore_broadcast_ssid=\).*/\1$dd/" /etc/hostapd/hostapd.conf

sudo killall -9 wpa_supplicant
sudo service hostapd stop
sudo service udhcpd stop
sudo service dhcpcd stop

sudo killall -9 udhcpd

sudo ip addr flush dev wlan0
sudo ifdown wlan0
sudo ifconfig wlan0 down
sudo ifconfig wlan0 up

sudo ifconfig wlan0 10.0.0.1 netmask 255.255.255.0
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo service hostapd start
sudo service udhcpd start
# sudo udhcpd /etc/udhcpd.conf
sudo service dhcpcd start
sudo iptables -t nat -F POSTROUTING
sudo iptables -F FORWARD
sudo sed -i "/net.ipv4.ip_forward=/d" /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo sh -c "echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf"
sudo iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

sudo update-rc.d hostapd enable
sudo update-rc.d udhcpd enable
sudo update-rc.d dhcpcd enable
