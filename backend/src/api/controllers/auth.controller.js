import { asyncHandler } from '../../utils/asyncHandler.js';
import { ApiError } from '../../utils/ApiError.js';
import { ApiResponse } from '../../utils/ApiResponse.js';
import { User, sequelize } from '../../models/index.js';
import { Op } from 'sequelize';

const registerUser = asyncHandler(async (req, res) => {
  const { email, password, first_name, last_name, phone_number } = req.body;

  // The validation is now handled by the `validate` middleware.

  // Check if user already exists by email or phone number
  const existingUser = await User.findOne({
    where: {
      [Op.or]: [{ email }, { phone_number: phone_number || null }],
    },
  });

  if (existingUser) {
    if (existingUser.email === email) {
      throw new ApiError(409, 'User with this email already exists');
    }
    if (phone_number && existingUser.phone_number === phone_number) {
      throw new ApiError(409, 'User with this phone number already exists');
    }
  }

  // Create user in DB. The password will be hashed by the model's beforeCreate hook.
  const user = await User.create({
    email,
    password_hash: password, // Pass the plain password to be hashed by the hook
    first_name,
    last_name,
    phone_number,
  });

  // Retrieve the created user to ensure we don't send back the password hash.
  const createdUser = await User.findByPk(user.id, {
    attributes: { exclude: ['password_hash'] },
  });

  if (!createdUser) {
    throw new ApiError(500, 'Something went wrong while registering the user');
  }

  return res.status(201).json(new ApiResponse(201, createdUser, 'User registered successfully'));
});

const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  // Find user in DB by email
  const user = await User.findOne({ where: { email } });

  if (!user) {
    throw new ApiError(404, 'User does not exist');
  }

  // Check password using the instance method from the model
  const isPasswordValid = await user.isPasswordCorrect(password);

  if (!isPasswordValid) {
    throw new ApiError(401, 'Invalid user credentials');
  }

  // Generate JWT
  const accessToken = user.generateAccessToken();

  // Get user data to return, excluding sensitive fields
  const loggedInUser = await User.findByPk(user.id, {
    attributes: { exclude: ['password_hash', 'fcm_token'] },
  });

  const options = {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
  };

  return res
    .status(200)
    .cookie('accessToken', accessToken, options)
    .json(
      new ApiResponse(
        200,
        { user: loggedInUser, accessToken },
        'User logged in successfully'
      )
    );
});

const getCurrentUser = asyncHandler(async (req, res) => {
  return res.status(200).json(new ApiResponse(200, req.user, "Current user fetched successfully."));
});

export { registerUser, loginUser, getCurrentUser };
