import { ApiError } from '../../utils/ApiError.js';

const validate = (schema) => (req, res, next) => {
  try {
    schema.parse(req.body);
    next();
  } catch (error) {
    // throw new ApiError(400, error.errors.map((e) => e.message).join(', '));
    res.json({
      status: 400,
      message: "Didnt Meet valdation requirements",
    });
  }
};

export { validate };