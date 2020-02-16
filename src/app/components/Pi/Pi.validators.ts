import * as Joi from '@hapi/joi';

export const PostPiSchema = Joi.object({
  minutes: Joi.number().optional(),
  state: Joi.string().optional()
});
