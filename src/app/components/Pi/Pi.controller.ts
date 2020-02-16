import * as debug from 'debug';
import { Request, Response, NextFunction } from 'express-serve-static-core';
const gpio = require('rpi-gpio');

const logger = debug('app:src/app/components/Pi/Pi.controller.ts');

const PIN = 7;
const TRUE = ["on", "yes", "true"];
/**
 * Example `Pi` controller
 */
export class PiController {

  /**
   * POST Show user's name
   * POST /api/Pi
   */
  public endpointPi = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const {
        body: {
          minutes,
          state
        },
      } = req;


      gpio.setup(7, gpio.DIR_HIGH, (err: any) => {
        if (err) {
          logger('endpointPi:: error: ', err);
          next(err);
        };
        if( TRUE.includes(state.toLowerCase())) {
          this.turnOn(minutes);
        } else {
          this.turnOff();
        }
        res.status(200).json({message: `Turning alarm: ${state} for ${minutes}minutes`});
      });

    } catch (err) {
      logger('endpointPi:: error: ', err);
      next(err);
    }
  }

  private turnOn = (minutes:number) => {
    logger('On');
    gpio.setup(PIN, gpio.DIR_HIGH, () => {
      gpio.write(PIN, 1);
      setTimeout(() => {
        logger('Off');
        gpio.write(PIN, 0, () => {
          gpio.destroy();
        });
      }, minutes * 60);
    });
  }

  private turnOff = () => {
    logger('Force Off');
    gpio.setup(PIN, gpio.DIR_HIGH, () => {
      gpio.write(PIN, 0);
    });
  }
}
