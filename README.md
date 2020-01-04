*NOTE:* This project is still in progress, while the configuration of the pi with the `motionEye` script works great, the `motion-detection-api` service still has some performance issue. We use `@tensorflow/tfjs` instead of `@tensorflow/tfjs-node` since the node version does not install well in PI as of now.


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


## Automatic configuration of MotionEye and motion-detection

To help getting started, I created 2 script:
- `motioneye.sh`: from a fresh rasbian install, it configures all you need for MotionEye to work with few more dependencies (Nodejs, C++ compiler). This script need to be run as sudo to work properly.
- `motion-detection.sh`: Script that dowload this repo (motion-detection repo), install and configure the process to restart automatically when the Pi reboot. This script should be run as the default `pi` user (not as sudo at least). This script will need to be updated with your own SMTP configuration before running it.

You can ether place both file on the SD card or copy them with SSH. Once done, connect to your pi on SSH, locate your 2 files (in the `/boot` folder usually), then run:

```sh
sudo chmod +x motioneye.sh motion-detection.sh
sudo ./motioneye.sh
./motion-detection.sh
```

### configure motionEye

From MotionEye web interface (http://<IP_PI>:8765), you can now configure the `Motion Notification` web hook with POST (form) and the URL to `http://localhost:5000/notify/?path=<SNAPSHOT_URL>&email=<EMAIL_ADDRESS>`.


## Manual configuration

This install step by step consider that the Pi is already in a working state (https://github.com/ccrisan/motioneye/wiki/Install-On-Raspbian) and you already have motionEye installed on it.

### Install

1. Pull the repo locally
```
wget --no-check-certificate --content-disposition https://github.com/R0muald/motioneye-detection/archive/master.zip
# --no-check-certificate was necessary for me to have wget not puke about https
curl -LJO https://github.com/R0muald/motioneye-detection/archive/master.zip
```

2. install
```
cd motioneye-detection
npm install
npm build
npm i pm2 -g
pm2 start pm2-process.json
```

### Make your server load when the Pi reboots

1. When connected to your Pi via SSH, type `npm install -g pm2` to do a global install of the pm2 module.
2. To run a server using pm2, go to your app directory and type `pm2 start pm2-process.json` . If you need to see if it’s running, type `pm2 ls` . If you need to stop it, type `pm2 delete 0` or whichever thread number you want to delete.
3. To discover and implement the appropriate boot strategy for pm2, type `pm2 startup`. In this case, pm2 will create a the file `/etc/systemd/system/pm2-pi.service` which will include the following line: `ExecStart=/home/pi/.nvm/versions/node/v8.0.0/lib/node_modules/pm2/bin/pm2 resurrect` . In other words, when the Pi boots, it will execute `pm2 resurrect`, which will load whatever pm2 threads you have saved.
4. In order to save the state of pm2 that you want to resurrect, run your server using `pm2 start pm2-process.json` and then type `pm2 save`.

For more details and commands for pm2, visit http://pm2.keymetrics.io/docs/usage/startup/

### Configure pi as bridge for camera

https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md#internet-sharing




## Development

To develop and contribut to this repo, here are the different scripts:

`yarn run dev`

- run the app in development mode, app will be reloaded on file changes

`yarn run start`

- start the app in non-reloadable mode

`yarn run build`

- build the app

`yarn run lint`

- check typescript errors via TSLint

`yarn run lint:fix`

- check and fix typescript errors via TSLint

`yarn run format`

- check for formatting errors via Prettier

`yarn run format:fix`

- fix formatting errors via Prettier

`yarn run format:lint:fix`

- check and fix typescript errors via TSLint and correct formatting errors via Prettier

### Project directory structure example

This project is based on the [Express TypeScript API Boilerplate github repo](https://github.com/jbutko/express-ts-api-boilerplate )

```

│   .editorconfig                         // https://editorconfig.org/
│   .env                                  // Base environment variables goes here. BEWARE: This one is commited in the repo, do not store sensitive variables here.
│   .env.local                            // Sensitive ENV variables goes here. Overrides variables from `/.env`. BEWARE: This one is not commited in the repo.
│   .gitignore                            // Git ignored files
│   .prettierignore                       // Prettier ignored files
│   .prettierrc                           // Prettier config file: no more tab/space bullshit with your collegues
│   LICENSE                               // License file, MIT of course
│   nodemon.json                          // Nodemon config file
│   package.json                          // App dependencies, project information and stuff...
│   pm2-process.json                      // PM2 process config file (start the app with command `pm2 start pm2-process.json`)
│   README.md                             // Project Readme
│   tsconfig.json                         // TypeScript config file
│   tslint.json                           // TypeScript linting config file
│   yarn.lock                             // Yarn lockfile => https://yarnpkg.com/blog/2016/11/24/lockfiles-for-all/
│
└───src                                   // App root folder
    │   index.ts                          // Main entry point: http server and express app initialization
    │
    ├───app                               // App folder
    │   │   App.routes.ts                 // Main express router: individual routers from `app/routers` folder are imported here
    │   │   App.ts                        // Express app config: middlewares, router initialization, error handling initialization
    │   │
    │   ├───components                    // All components (entities) goes here
    │   │   └───Common                    // Common component example
    │   │           Common.controller.ts  // API controller for `Common` component: API endpoint handlers goes here, keep it simple!
    │   │           Common.validators.ts  // Joi validation schemas. Imported in `app/routers` files.
    │   │           Common.interface.ts   // TypeScript interfaces/enums for `Common` component
    │   │           Common.db.ts          // Database access related code
    │   │           Common.service.ts     // Generic functions related to data processing or stuff that do not need db access
    │   │           Common.middleware.ts  // Express middleware functions: for example user auth token verification etc. Imported in `app/routers` files.
    │   │           index.ts              // Public API of `Common` component: CommonController, commonValidators etc.
    │   │
    │   ├───core                          // Core components: common logic that is used in more than one place of the app
    │   │       Env.ts                    // Environment settings configuration through dotenv - variables from `/.env` and `./env.local` will be initialized here.
    │   │       ErrorHandling.ts          // Express error handler functions for prod/dev
    │   │       Dates.ts                  // All dates/times related functions
    │   │       index.ts                  // Public API of `core` folder: ENV, ErrorHandling etc.
    │   │
    │   └───routers                       // Routers for individual components from `components` folder
    │           Common.router.ts          // API Endpoint handlers for `Common` controller
    │           index.ts                  // All exported routers
    │
    └───types                             // TypeScript definition files goes here
            types.d.ts                    // Generic typescript definition file

```

### Debugging

If you need to debug some of your code during development, it's very easy. Open following URL in Chrome: `chrome://inspect/#devices`. Click on `Open dedicated DevTools for Node` => DevTools should open. Use `Ctrl + P` shortcut to find the file you need, for example `Common.controller.ts`. After adding a breakpoint the TypeScript file should be opened directly in devtools.

**Note:** If inspect mode does not work for you, you need to configure ports by clicking on `Configure` button in `chrome://inspect/# devices`. The websocket port through which the inspect mode works is displayed during app launch in the command line ("Debugger listening on ws://127.0.0.1:9229/..."). In this example you need to add `localhost:9229` in `Configure` settings.

### API Endpoints params validation

To validate input params sent from API user [Joi](https://github.com/hapijs/joi) package is used. At first you need to define validation schemas ([example](https://github.com/jbutko/motioneye-detection/blob/master/src/app/components/Common/Common.validators.ts)). The next step is to import schemas in your router, instantiate Joi validator and use it as middleware. This way you can separate params validation logic out of controllers. Check the [example](https://github.com/jbutko/motioneye-detection/blob/master/src/app/routers/Common.router.ts).

### Production deployment example

Clone the repo on any unix (cloud) server. Make a build of the app:

```
yarn run build
```

Install [pm2](https://github.com/Unitech/pm2) process manager:

```
yarn add -g pm2
```

Start the app:

```
pm2 start pm2-process.json
```

App will be started in daemon mode (background). To check the logs of the app issue following command:

```
pm2 logs nameOfTheAppFromPm2
```

You can find the name of the app in `pm2-process.json` file.





