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
MAIL_HOST="in-v3.mailjet.com"
MAIL_USER="ab69e2d34cc969560e992dbfcaf5ce86"
MAIL_PASS="603871e8810838f98706e092ba520f8f"
MAIL_FROM="no-reply@fdelpech.com"
EOF

npm i pm2 -g

npm install
npm run build
pm2 start pm2-process.json
# boot strategy
pm2 startup
pm2 save


# Configure wifi as bridge



