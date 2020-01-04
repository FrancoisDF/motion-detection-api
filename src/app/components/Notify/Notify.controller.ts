import * as debug from 'debug';
import { Request, Response, NextFunction } from 'express-serve-static-core';
import { Classify } from '../../core/classify';
import { sendEmail } from '../../core/email';
const logger = debug('app:src/app/components/Notify/Notify.controller.ts');

/**
 * Example `Notify` controller
 */
export class NotifyController {

  private classify: Classify;

  constructor() {
    this.classify = new Classify();
  }
  /**
   * POST Show user's name
   * POST /api/Notify
   */
  public endpointNotify = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const {
        body: {
          email,
          path
        },
      } = req;

      const image = await this.classify.loadImage(path);
      const foundPerson = await this.classify.detect(image, 'person');

      if(foundPerson) {
        email && sendEmail(email, image)
      }
      res.status(200).json(foundPerson);
    } catch (err) {
      logger('endpointNotify:: error: ', err);
      next(err);
    }
  };
}