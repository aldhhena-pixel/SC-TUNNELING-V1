#!/bin/bash

#install
cp /media/cybervpn/var.txt /tmp

clear

cp /root/cybervpn/var.txt /tmp

clear

rm -rf cybervpn

clear

apt update && apt upgrade -y
apt install python3 python3-pip -y
apt install sqlite3 -y
cd /media/
rm -rf cybervpn

clear

wget https://raw.githubusercontent.com/aldhhena-pixel/SC-TUNNELING-V1/main/limit/cybervpn.zip
unzip cybervpn.zip
cd cybervpn
rm var.txt

clear

rm database.db

clear

# Install dependencies
apt update && apt upgrade -y
apt install python3 python3-pip git python3-venv -y

# Set up a virtual environment
cd /usr/bin
python3 -m venv /media/cybervpn/venv

# Activate the virtual environment and install dependencies
source /media/cybervpn/venv/bin/activate
pip install telethon
pip install pillow
pip install speedtest-cli
pip3 install aiohttp
pip3 install paramiko
pip install -r /media/cybervpn/requirements.txt
deactivate

#isi data
sldns=$(cat /root/nsdomain)
domain=$(
