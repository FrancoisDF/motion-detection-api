# Motion detection API

This project has been developed to provide a small AI capability to motionEye security system and help to analyse if the motion came from a person moving in the field.
In case of recognized person, it will automatically send and email with the attached picture.


## Motivation

The main goal, on top of learning more about deep learning, was to add an local AI capability to the already great MotionEye project without having to pay for cloud API processing. This project uses the open source [TensorFlow Lite](https://www.tensorflow.org/lite) as AI to recognize the motion. An email/alert will be send only if a person has been seen, not if a light turned on or a cat passed by.

## Technologies and Packages used

The small server has been created as an API server that run the PI and start processing images by Path (located on the PI) or by URL.

- `NodeJs`, `Express`, `Typescript` for the API server
- `Tensorflow Lite` as AI capability to run the model locally and test the picture
- `nodemailer` to send emails with pre-configured SMTP server
- `PM2` To start eh service in production ready and configure the service to restart then the pi restart
- `raspap` To create a GUI to configure the wifi hotspot of the different camera (raspap.com)[https://raspap.com/]

## Configure in a server

If you don't want to configure and run this project on a raspberry pi, you can use docker to deploy the app.

1. update the `.env` file with your SMTP variables
2. Run docker:
  ```
  docker build -t me/motion-detection-api .
  docker run -p 5000:5000 me/motion-detection-api
  ```

## Configure in a Raspberry PI

*NOTE:* This project is still in progress, while the configuration of the pi with the `motionEye` script works great, the `motion-detection-api` service still has some performance issue. You need to use `@tensorflow/tfjs` instead of `@tensorflow/tfjs-node` since the node version does not install well in PI as of now. This result in an important performance drop.


### Script configuration of MotionEye and motion-detection

To help getting started, I created 2 script:
- `motioneye.sh`: from a fresh rasbian install, it configures all you need for MotionEye to work with few more dependencies (Nodejs, C++ compiler). This script need to be run as sudo to work properly.

You can ether place both file on the SD card or copy them with SSH. Once done, connect to your pi on SSH, locate your 2 files (in the `/boot` folder usually), then run:

```sh
wget --no-check-certificate --content-disposition https://github.com/R0muald/motioneye-detection/archive/master.zip
unzip motioneye-detection-master.zip
mv motioneye-detection-master motioneye-detection
cd ./motioneye-detection
sudo chmod +x motioneye.sh motion-detection.sh
sudo ./motioneye.sh
```
restart your py:
```
sudo reboot
```

Update `.env.local` with your own MAIL configuration then run it:

```sh
npm install
npm run build
pm2 start pm2-process.json
# boot strategy
pm2 startup
pm2 save
```


#### configure motionEye

From MotionEye web interface (http://<IP_PI>:8765), you can now configure the `Motion Notification` web hook with POST (form) and the URL to `http://localhost:5000/notify/?path=<SNAPSHOT_URL>&email=<EMAIL_ADDRESS>`.

#### Configure pi as a hotspot with [raspap](https://github.com/billz/raspap-webgui)


Once Raspap installed, you will need to open the web interface and configure the hotspot:
- Basic Tab:
  - SSID: <YOUR_SSID_NAME> (store it somewhere)
  - Wireless mode: `802.11n - 2.4GHz` (to be compatible with the Raspberry Pi zero W)
- Security Tab:
  - type: `WPA`
  - encryption: `CCMP`
  - PSK: <YOUR_PSK_KEY> (store it somewhere)
- Advanced Tab:
  - Hide SSID in broadcast: `Enabled`

## Configure Pi zero with [motionEyeOS](https://github.com/ccrisan/motioneyeos/wiki)

1. Download the latest stable release `img` file (https://github.com/ccrisan/motioneyeos/releases)
2. Use [Ether.io](https://www.balena.io/etcher/) to burn a SD  card with the image
3. Before putting the card in the RPI Zero,
    1. If you want to access the pi with `ssh`, create an empty `ssh.txt` or `ssh` file at the root of the SD card (usually called `/boot`)
    2. Create a file called `wpa_supplicant.conf` with:
        ```
        update_config=1
        ap_scan=1
        ctrl_interface=/var/run/wpa_supplicant
        network={
          scan_ssid=1
          ssid="<YOUR_SSID_NAME>"
          psk="<YOUR_PSK_KEY>"
          key_mgmt=WPA-PSK
        }
        ```



