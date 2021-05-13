
# Raspberry Pi Wifi Repeater
Features:
 - Tested on Raspbian Jessy, Stretch
 - Can install while wlan0 is connected to network.
 - easy to switch betwwen stattion mode and hotspot mode.
 - can share internet between eth0 and wlan0, can be config to share with wlan1 or ...
 
Introduction:
- This guide will help you use your RPI as a wifi repeater!
 
 **IMPORTANT NOTICE**
 You must have a Raspberry Pi 3,4 to complete this project!
 You can use other models but you will need a wifi dongle!
 The setup for the dongle will not be included!
 ****
 
Setup:
```bash
git clone https://github.com/atharv-kopparthi/Raspberry-Pi-Wifi-Repeater.git
sudo ./install.sh
```
Test:
- Station mode: sudo sta [SSID] [password] - Connect to a network with specific ssid name and password
,example:
```bash
sudo sta mySSID  myPass
```
- Station mode: sudo sta  - Connect to a network with saved ssid name and password
,example:
```bash
sudo sta
```
- AP mode: sudo ap [SSID] [pass] - Create an wifi hotspot with specific ssid and pass
,example: 
```bash
sudo ap my_ssid 12345678
```
- AP mode: sudo ap [SSID]  - Create an wifi hotspot with specific ssid and no pass
,example: 
```bash
sudo ap mySSID_wifi
```
Bugs:
- station mode somtime need to run more than 1 time or need to be restart the board.
- work with 2.4GHz wifi(RPI3 not support 5GHz wifi)
- Still trying to get 5ghz on RPI4 

