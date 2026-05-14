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

# REPO
REPO="https://raw.githubusercontent.com/aldhhena-pixel/SC-TUNNELING-V1/main/"

# TELEGRAM
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
if [[ $(uname -m) != "x86_64" ]]; then
 echo -e "${RED}Architecture Tidak Support${NC}"
 exit 1
fi

# CEK OS
OS=$(grep -w ID /etc/os-release | head -n1 | cut -d= -f2 | tr -d '"')

if [[ "$OS" != "ubuntu" && "$OS" != "debian" ]]; then
 echo -e "${RED}OS Tidak Support${NC}"
 exit 1
fi

echo ""
read -p "Tekan ENTER untuk lanjut install..."

clear

if [ "$EUID" -ne 0 ]; then
 echo "Jalankan sebagai root"
 exit 1
fi

# UPDATE
apt update -y && apt upgrade -y

# PACKAGE
apt install -y curl wget unzip sudo git cron socat dos2unix nginx screen jq net-tools haproxy fail2ban vnstat neofetch figlet ruby-full lolcat python3 python3-pip

# FOLDER
mkdir -p /etc/xray /var/log/xray /usr/local/sbin /var/www/html
touch /etc/xray/domain /var/log/xray/access.log /var/log/xray/error.log

# DOMAIN
clear
echo "1. Pakai Domain Sendiri"
echo "2. Pakai Domain Random"
read -p "Pilih : " host

if [[ "$host" == "1" ]]; then
 read -p "Domain : " domain
 echo "$domain" > /etc/xray/domain
else
 wget -q ${REPO}limit/cf.sh -O cf.sh
 bash cf.sh
 rm -f cf.sh
fi

domain=$(cat /etc/xray/domain)

# XRAY
clear
echo "Install Xray..."
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data

wget -O /etc/xray/config.json "${REPO}limit/config.json"
sed -i "s/xxx/${domain}/g" /etc/xray/config.json

systemctl enable xray && systemctl restart xray

# NGINX
clear
echo "Install Nginx..."
wget -O /etc/nginx/nginx.conf "${REPO}limit/nginx.conf"
wget -O /etc/nginx/conf.d/xray.conf "${REPO}limit/xray.conf"

sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf

systemctl enable nginx && systemctl restart nginx

# SSL
clear
echo "Install SSL..."
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

systemctl stop nginx

~/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256

~/.acme.sh/acme.sh --installcert -d $domain \
 --fullchainpath /etc/xray/xray.crt \
 --keypath /etc/xray/xray.key --ecc

chmod 777 /etc/xray/xray.key

systemctl restart nginx xray

# MENU
clear
echo "Install Menu..."

cd /root
rm -rf menu menu.zip

wget -O menu.zip ${REPO}limit/menu.zip
unzip -o menu.zip

chmod +x menu

mv add* cek* del* renew* bot* m-* clearlog restart /usr/local/sbin/ 2>/dev/null
mv menu /usr/local/sbin/

chmod +x /usr/local/sbin/*

rm -f /usr/bin/menu
ln -s /usr/local/sbin/menu /usr/bin/menu

# FIX SAFE (hapus error tanpa merusak script)
if grep -q "Masa Aktif Script Kamu Sudah Habis" /usr/local/sbin/menu; then
 sed -i '/Masa Aktif Script Kamu Sudah Habis/,+8d' /usr/local/sbin/menu
fi

chmod +x /usr/local/sbin/menu

# PROFILE FIX (ANTI EOF ERROR)
cat >/root/.profile <<'EOF'
if [ "$BASH" ]; then
 if [ -f ~/.bashrc ]; then
  . ~/.bashrc
 fi
fi

mesg n || true
/usr/local/sbin/menu
EOF

# CRON
echo "*/10 * * * * root > /var/log/xray/access.log" > /etc/cron.d/clearlog
echo "*/10 * * * * root > /var/log/nginx/access.log" >> /etc/cron.d/clearlog

systemctl restart cron

# ENABLE SERVICE
systemctl enable nginx xray haproxy fail2ban vnstat

# CLEAN
history -c
rm -rf /root/*.zip

clear

echo -e "${Green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${Green}INSTALL BERHASIL${NC}"
echo -e "${Green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Domain : ${YELLOW}$domain${NC}"
echo -e "Ketik menu untuk masuk"
echo ""

read -p "ENTER untuk reboot..."
reboot
