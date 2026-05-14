<h1 align="center">
<h1 align="center">Autoscript Tunneling VIP

### INSTALL SCRIPT SESUAI STEP

- step 1
```bash
apt update -y && apt upgrade -y --fix-missing && apt install -y xxd bzip2 wget curl sudo lsof socat net-tools bc coreutils build-essential bsdmainutils screen dos2unix && update-grub && apt dist-upgrade -y && sleep 2 && reboot
```

- step 2
```bash
screen -S setup-session bash -c "wget -q https://raw.githubusercontent.com/aldhhena-pixel/SC-TUNNELING-V1/main/install.sh && chmod +x install.sh && ./install.sh; read -p 'Tekan enter untuk keluar...'"
```

### PERINTAH UNTUK MENGHUBUNGKAN ULANG JIKA DISCONNECTED SAAT PEMASANGAN
```bash
screen -r -d setup
```

### PERINTAH UPDATE
```bash
wget https://raw.githubusercontent.com/aldhhena-pixel/SC-TUNNELING-V1/main/update.sh && chmod +x update.sh && ./update.sh
```

### TESTED ON OS
- UBUNTU 20.04.05
- DEBIAN 10

### FITUR TAMBAHAN
- Tambah Swap 1GiB
- Pemasangan yang dinamis
- Tuning profile pada server
- Xray Core
- Penambahan fail2ban
- Auto block sebagian ads indo by default
- Auto clear log per 3 menit
- Auto delete expired
- User Details Akun

### PORT INFO
```text
- TROJAN WS 443
- TROJAN GRPC 443
- SHADOWSOCKS WS 443
- SHADOWSOCKS GRPC 443
- VLESS WS 443
- VLESS GRPC 443
- VLESS NONTLS 80
- VMESS WS 443
- VMESS GRPC 443
- VMESS NONTLS 80
- SSH WS / TLS 443
- SSH NON TLS 8880
- OVPN SSL/TCP 1194
- SLOWDNS 5300
```

### SETTING CLOUDFLARE
```text
- SSL/TLS : FULL
- SSL/TLS Recommender : OFF
- GRPC : ON
- WEBSOCKET : ON
- Always Use HTTPS : OFF
- UNDER ATTACK MODE : OFF
```

## SYSTEM SUPPORT

### Debian:
- 10 (Buster)
- 11 (Bullseye)
- 12 (Bookworm)

### Ubuntu:
- 20.04 LTS (Focal)
- 22.04 LTS (Jammy)
- 24.04 LTS (Noble)

### Kali Linux:
- Kali Linux Rolling

### Virtualization:
- Xen
- KVM
- VMware
- Proxmox
- Virtuozzo
- OpenVZ 7

### Minimum Specifications:
- RAM 512MB
- SSD 10GB
- 1 vCPU

### Recommended Specifications:
- 1vCPU
- 1GB RAM
- 10GB SSD

## Architecture Support:
- x86-64 (64-bit)

<p align="center">
<a href="https://github.com/aldhhena-pixel"><img title="GitHub" src="https://img.shields.io/badge/GITHUB-aldhhena--pixel-green?style=for-the-badge&logo=github"></a>
</p>

<p align="center">
<a href="https://github.com/aldhhena-pixel/SC-TUNNELING-V1"><img title="Repository" src="https://img.shields.io/badge/REPOSITORY-SC--TUNNELING--V1-blue?style=for-the-badge&logo=github"></a>
</p>
