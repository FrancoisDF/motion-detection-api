import { Router } from 'express';
import { createValidator } from 'express-joi-validation';
import { NotifyController, notifyValidators } from '../components/Notify';

export class NotifyRouter {
  public router: Router;
  protected notifyController: NotifyController;
  protected validator: any;

  constructor() {
    this.notifyController = new NotifyController();
    this.validator = createValidator({ passError: true });
    this.router = this.initRouter();
  }

  /**
   * Notify router
   */
  private initRouter(): Router {
    const router: Router = Router();

    router
      .post(
        '/',
        this.validator.body(notifyValidators.PostNotifySchema),
        this.notifyController.endpointNotify
      );

    return router;
  }
}

export const notifyRouter = new NotifyRouter();
