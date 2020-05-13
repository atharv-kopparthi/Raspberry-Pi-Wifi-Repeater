#! /bin/bash
if [ -z "$1" ]
then
  echo "No Input Name, select default name:ThanhLe_handsome"
  name="ThanhLe_handsome"
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
sudo service wpa_supplicant stop
sudo killall -9 wpa_supplicant
sudo service hostapd stop
sudo service udhcpd stop
sudo service dhcpcd stop
sudo service dnsmasq stop
sudo ip addr flush dev wlan0
sudo ifdown wlan0
sudo ifconfig wlan0 down
sudo rm -rf /etc/network/interfaces
sudo cp /etc/network/interfaces.ap /etc/network/interfaces
sudo ifconfig wlan0 up
sudo service hostapd start
sudo service udhcpd start
sudo service dhcpcd start
sudo service dnsmasq start
sudo service hostapd status
sudo service udhcpd status
sudo service dnsmasq status
sudo ifconfig wlan0 up
sudo ifup wlan0
