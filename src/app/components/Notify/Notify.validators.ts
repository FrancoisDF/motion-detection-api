import * as Joi from '@hapi/joi';

export const PostNotifySchema = Joi.object({
  path: Joi.string().required(),
  email: Joi.string().optional()
});
