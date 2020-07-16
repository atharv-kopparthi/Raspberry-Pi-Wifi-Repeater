#! /bin/bash
w_if="$(iw dev | grep Interface | awk '{print $2}' | cut -d/ -f1)"
if [ -z  "${w_if}" ] ; then
    echo "Not found wireless interface in $(uname -a | awk '{print $2}' | cut -d/ -f1)"
    exit
fi
e_if="$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2}')"
if [ -z  "${e_if}" ] ; then
    echo "Not found ethernet interface in $(uname -a | awk '{print $2}' | cut -d/ -f1)"
    exit
fi
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

sudo ip addr flush dev ${w_if}
sudo ifdown ${w_if}
sudo ifconfig ${w_if} down
sudo ifconfig ${w_if} up

sudo ifconfig ${w_if} 10.0.0.1 netmask 255.255.255.0
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
sudo iptables -t nat -I POSTROUTING -o ${e_if} -j MASQUERADE
sudo iptables -A FORWARD -i ${e_if}  -o ${w_if} -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ${w_if} -o ${e_if}  -j ACCEPT

sudo update-rc.d hostapd enable
sudo update-rc.d udhcpd enable
sudo update-rc.d dhcpcd enable
