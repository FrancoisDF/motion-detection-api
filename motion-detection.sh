#!/bin/bash

####
# Configure Raspberry pi with motioneye-detection with auto start on boot
####
# Copy latest motioneye-detection repo from github

cd /home/pi

wget --no-check-certificate --content-disposition https://github.com/R0muald/motioneye-detection/archive/master.zip
unzip motioneye-detection-master.zip
mv motioneye-detection-master motioneye-detection

cd ./motioneye-detection
# Configure .env.local with corresponding information
cat >> .env.local <<EOF
MAIL_HOST="<HOST>COM>"
MAIL_USER="<USERNAM>"
MAIL_PASS="<PASSWORD>"
MAIL_FROM="<no-reply@DOMAIN.com"
EOF

npm i pm2 -g

npm install
npm run build
pm2 start pm2-process.json
# boot strategy
pm2 startup
pm2 save

