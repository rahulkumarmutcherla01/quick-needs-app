import jwt from 'jsonwebtoken';
import { ApiError } from '../../utils/ApiError.js';
import { asyncHandler } from '../../utils/asyncHandler.js';
import { User } from '../../models/index.js';
import config from '../../config/index.js';

export const verifyJWT = asyncHandler(async (req, _, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
      throw new ApiError(401, 'Unauthorized request');
    }

    const decodedToken = jwt.verify(token, config.jwt.secret);
    const user = await User.findByPk(decodedToken?.id, {
      attributes: { exclude: ['password_hash', 'fcm_token'] },
    });

    if (!user) {
      throw new ApiError(401, 'Invalid Access Token');
    }

    req.user = user;
    next();
  } catch (error) {
    throw new ApiError(401, error?.message || 'Invalid access token');
  }
});
