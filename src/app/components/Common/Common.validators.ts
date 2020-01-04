import * as Joi from '@hapi/joi';

export const PostDisplayNameSchema = Joi.object({
  name: Joi.string().required(),
});
