#!/bin/bash
clear
export DEBIAN_FRONTEND=noninteractive

# WARNA
FONT='\033[0m'
Green="\e[92;1m"
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE="\033[36m"
BIWhite="\033[1;97m"
LIME='\e[38;5;155m'
ungu="\e[38;5;99m"
NC='\033[0m'

# REPO GITHUB
REPO="https://raw.githubusercontent.com/aldhhena-pixel/SC-TUNNELING-V1/main/"

# TELEGRAM NOTIF
TIMES="10"
CHATID=""
KEY=""
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

# UPDATE PACKAGE
apt update -y
apt upgrade -y

# INSTALL PACKAGE
apt install -y \
 curl wget unzip sudo git cron socat dos2unix nginx screen jq \
 net-tools haproxy fail2ban vnstat neofetch figlet ruby-full lolcat \
 python3 python3-pip

# BUAT FOLDER
mkdir -p /etc/xray
mkdir -p /var/log/xray
mkdir -p /usr/local/sbin
mkdir -p /var/www/html

touch /etc/xray/domain
touch /var/log/xray/access.log
touch /var/log/xray/error.log

# DOMAIN
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Pakai Domain Sendiri"
echo "2. Pakai Domain Random"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

read -p "Pilih Opsi : " host

if [[ $host == "1" ]]; then
 read -p "Masukkan Domain : " host1
 echo $host1 >/etc/xray/domain
 echo $host1 >/root/domain
else
 wget -q ${REPO}limit/cf.sh
 chmod +x cf.sh
 bash cf.sh
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
clear
echo "Installing Nginx..."

wget -O /etc/nginx/nginx.conf "${REPO}limit/nginx.conf"
wget -O /etc/nginx/conf.d/xray.conf "${REPO}limit/xray.conf"

sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf

systemctl enable nginx
systemctl restart nginx

# INSTALL SSL
clear
echo "Installing SSL..."

curl https://get.acme.sh | sh

~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

systemctl stop nginx

~/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256

~/.acme.sh/acme.sh --installcert -d $domain \
 --fullchainpath /etc/xray/xray.crt \
 --keypath /etc/xray/xray.key --ecc

chmod 777 /etc/xray/xray.key

systemctl restart nginx
systemctl restart xray

# DOWNLOAD MENU
clear
echo "Downloading Menu..."

cd /root

wget -O menu.zip ${REPO}limit/menu.zip

unzip -o menu.zip

chmod +x menu/*

mv menu/* /usr/local/sbin

chmod +x /usr/local/sbin/*

ln -sf /usr/local/sbin/menu /usr/bin/menu

rm -rf menu
rm -rf menu.zip

# HAPUS LICENSE CHECKER
sed -i '/arivpnstores\/izin/d' /usr/local/sbin/menu
sed -i '/Masa Aktif Script Kamu Sudah Habis/d' /usr/local/sbin/menu
sed -i '/Whatsapp =/d' /usr/local/sbin/menu
sed -i '/Telegram =/d' /usr/local/sbin/menu

chmod +x /usr/local/sbin/menu

# PROFILE
cat >/root/.profile <<EOF
if [ "\$BASH" ]; then
 if [ -f ~/.bashrc ]; then
  . ~/.bashrc
 fi
fi

mesg n || true
/usr/local/sbin/menu
EOF

# AUTO CLEAR LOG
echo "*/10 * * * * root echo -n > /var/log/xray/access.log" >/etc/cron.d/clearlog
echo "*/10 * * * * root echo -n > /var/log/nginx/access.log" >>/etc/cron.d/clearlog

# ENABLE SERVICE
systemctl daemon-reload
systemctl enable cron
systemctl restart cron

systemctl enable nginx
systemctl enable xray
systemctl enable haproxy
systemctl enable fail2ban
systemctl enable vnstat

systemctl restart nginx
systemctl restart xray
systemctl restart haproxy
systemctl restart fail2ban
systemctl restart vnstat

# TELEGRAM NOTIF
if [[ ! -z "$CHATID" && ! -z "$KEY" ]]; then

TEXT="
<b>INSTALL VPS SUCCESS</b>

Domain : <code>$domain</code>
IP VPS : <code>$IP</code>

<i>Install selesai dari Github pribadi</i>
"

curl -s --max-time $TIMES \
-d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" \
$URL >/dev/null

fi

# CLEAN
history -c

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
reboo
