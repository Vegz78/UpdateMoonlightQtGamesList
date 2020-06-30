#!/bin/bash
clear
echo "Waking Game Streaming Server..."
sudo wakeonlan aa:bb:cc:dd:ee:ff  
#You must install wakeonlan(sudo apt install wakeonlan) and change this MAC address to the MAC of your game streaming server
#for this script to work
