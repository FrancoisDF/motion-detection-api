import * as Joi from 'joi';

export const PostNotifySchema = Joi.object({
  path: Joi.string().required(),
  email: Joi.string().optional()
});
