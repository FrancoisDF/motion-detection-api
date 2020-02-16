#!/bin/bash

####
# Configure Raspberry pi with motioneye from a raspbian instance
# https://technodezi.co.za/Post/running-face-apijs-or-tfjs-node-on-a-raspberry-pi-and-nodejs
####
apt-get purge wolfram-engine -y
apt-get purge libreoffice* -y
apt-get clean
apt-get autoremove -y

# Update system
apt-get apt-get update & sudo apt-get -y dist-upgrade

# Install motioneye
apt-get install ffmpeg libmariadb3 libpq5 libmicrohttpd12 -y
wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb
dpkg -i pi_buster_motion_4.2.2-1_armhf.deb
apt-get install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev -y
pip install motioneye
mkdir -p /etc/motioneye
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
mkdir -p /var/lib/motioneye
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye


# Configure Samba to access video from the network (This will prompt a message to validate)

apt-get install samba samba-common-bin

cat >> /etc/samba/smb.conf <<EOF
[pimylifeupshare]
path = /home/pi/shared
writeable=yes
create mask=0777
directory mask=0777
public=yes
EOF

systemctl restart smbd

# Install npm
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs gcc g++ make

# Install Build Tools and additional components:
npm install -g node-gyp
npm install -g node-pre-gyp
apt-get update
apt-get install cmake
apt-get install build-essential pkg-config
apt-get install libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev

# Configure local node project
npm i pm2 -g

cat >> .env.local <<EOF
MAIL_HOST="<HOST_COM>"
MAIL_USER="<USERNAM>"
MAIL_PASS="<PASSWORD>"
MAIL_FROM="<no-reply@DOMAIN.com"
EOF

# Configure

curl -sL https://install.raspap.com | bash -s -- -y



