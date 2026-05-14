#!/bin/bash
clear
export DEBIAN_FRONTEND=noninteractive

# WARNA
FONT='\033[0m'
Green="\e[92;1m"
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE="\033[36m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
IGreen="\033[0;92m"
BIYellow="\033[1;93m"
BICyan="\033[1;96m"
BIWhite="\033[1;97m"
GRAY="\e[1;30m"
WHITE='\033[1;37m'
LIME='\e[38;5;155m'
ungu="\e[38;5;99m"
NC='\033[0m'

# GANTI REPO DISINI
REPO="https://raw.githubusercontent.com/AldyYz/v7/main/"

TIMES="10"
CHATID="ISI_ID_TELEGRAM"
KEY="ISI_BOT_TOKEN"
URL="https://api.telegram.org/bot$KEY/sendMessage"

clear
export IP=$(curl -sS icanhazip.com)

echo -e "${BIWhite}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${LIME}AUTOSCRIPT VPN PREMIUM ALDY PROJECT${NC}"
echo -e "${BIWhite}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

sleep 2

# CEK ARCH
if [[ $(uname -m) == "x86_64" ]]; then
echo -e "${BIWhite}Architecture Supported (${ungu}$(uname -m)${BIWhite})${NC}"
else
echo -e "${RED}Architecture Tidak Support${NC}"
exit 1
fi

# CEK OS
OS=$(grep -w ID /etc/os-release | head -n1 | sed 's/ID=//g' | tr -d '"')

if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
echo -e "${BIWhite}OS Supported (${ungu}$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')${BIWhite})${NC}"
else
echo -e "${RED}OS Tidak Support${NC}"
exit 1
fi

echo ""
read -p "$(echo -e "${BIWhite}Tekan ${YELLOW}[ ENTER ]${NC} ${BIWhite}Untuk Memulai Install${NC}")"

clear

if [ "${EUID}" -ne 0 ]; then
echo "Jalankan script sebagai root"
exit 1
fi

# INSTALL PACKAGE
apt update -y
apt upgrade -y
apt install -y curl wget unzip sudo git cron socat dos2unix nginx screen jq net-tools

# BUAT FOLDER
mkdir -p /etc/xray
mkdir -p /var/log/xray
mkdir -p /usr/local/sbin

touch /etc/xray/domain
touch /var/log/xray/access.log
touch /var/log/xray/error.log

# DOMAIN
clear
echo "1. Pakai Domain Sendiri"
echo "2. Pakai Domain Random"

read -p "Pilih Opsi : " host

if [[ $host == "1" ]]; then
read -p "Masukkan Domain : " host1
echo $host1 >/etc/xray/domain
echo $host1 >/root/domain
else
wget -q ${REPO}limit/cf.sh
chmod +x cf.sh
./cf.sh
rm -f cf.sh
fi

domain=$(cat /etc/xray/domain)

# INSTALL XRAY
clear
echo "Installing Xray..."

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data

wget -O /etc/xray/config.json "${REPO}limit/config.json"

sed -i "s/xxx/${domain}/g" /etc/xray/config.json

systemctl enable xray
systemctl restart xray

# INSTALL NGINX
wget -O /etc/nginx/nginx.conf "${REPO}limit/nginx.conf"
wget -O /etc/nginx/conf.d/xray.conf "${REPO}limit/xray.conf"

sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf

systemctl enable nginx
systemctl restart nginx

# SSL
clear
echo "Installing SSL..."

apt install -y socat cron

curl https://get.acme.sh | sh

~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

~/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256

~/.acme.sh/acme.sh --installcert -d $domain \
--fullchainpath /etc/xray/xray.crt \
--keypath /etc/xray/xray.key --ecc

chmod 777 /etc/xray/xray.key

systemctl restart nginx
systemctl restart xray

# MENU INSTALL
clear
echo "Downloading Menu..."

wget ${REPO}limit/menu.zip
unzip menu.zip
chmod +x menu/*
mv menu/* /usr/local/sbin

rm -rf menu
rm -rf menu.zip

# PROFILE
cat >/root/.profile <<EOF
if [ "\$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
menu
EOF

# AUTO CLEAR LOG
echo "*/10 * * * * root echo -n > /var/log/xray/access.log" >/etc/cron.d/clearlog
echo "*/10 * * * * root echo -n > /var/log/nginx/access.log" >>/etc/cron.d/clearlog

# RESTART SERVICE
systemctl daemon-reload
systemctl enable cron
systemctl restart cron

# NOTIF TELEGRAM
TEXT="
<b>INSTALL VPS SUCCESS</b>

Domain : <code>$domain</code>
IP VPS : <code>$IP</code>

<i>Install selesai dari Github pribadi</i>
"

curl -s --max-time $TIMES \
-d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" \
$URL >/dev/null

# CLEAN
history -c
rm -rf /root/*.sh
rm -rf /root/*.zip

clear

echo -e "${Green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${Green}INSTALL SCRIPT BERHASIL${NC}"
echo -e "${Green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Domain : ${YELLOW}$domain${NC}"
echo -e "Repo   : ${YELLOW}$REPO${NC}"
echo ""
echo -e "Ketik ${YELLOW}menu${NC} untuk membuka menu"
echo ""

read -p "Tekan ENTER untuk reboot..."
reboot
