#!/bin/bash

####
# Configure Raspberry pi with motioneye from a raspbian instance
# https://technodezi.co.za/Post/running-face-apijs-or-tfjs-node-on-a-raspberry-pi-and-nodejs
####

# Update system
apt update & apt -y dist-upgrade
apt --fix-broken install -y

# Install motioneye
apt install ffmpeg libmariadb3 libpq5 libmicrohttpd12 -y
wget https://github.com/Motion-Project/motion/releases/download/release-4.3.2/pi_buster_motion_4.3.2-1_armhf.deb
dpkg -i pi_buster_motion_4.3.2-1_armhf.deb
apt install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev -y
pip install motioneye
mkdir -p /etc/motioneye
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
mkdir -p /var/lib/motioneye
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye


# Configure Samba to access video from the network (This will prompt a message to validate)

apt install samba samba-common-bin -y

cat >> /etc/samba/smb.conf <<EOF
[pimylifeupshare]
path = /home/pi/shared
writeable=yes
create mask=0777
directory mask=0777
public=yes
EOF

systemctl restart smbd

# Install npm and yarn
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt install -y nodejs gcc g++ make
curl -o- -L https://yarnpkg.com/install.sh | bash --


# Install Build Tools and additional components:
npm install -g node-gyp -y
npm install -g node-pre-gyp -y
apt install cmake -y
apt install build-essential pkg-config -y
apt install libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev -y

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


apt purge wolfram-engine -y
apt purge libreoffice* -y
apt clean
apt autoremove -y
