import { nanoid } from 'nanoid';
import { asyncHandler } from '../../utils/asyncHandler.js';
import { ApiError } from '../../utils/ApiError.js';
import { ApiResponse } from '../../utils/ApiResponse.js';
import { Family, UserFamily, User, sequelize } from '../../models/index.js';

/**
 * @description Create a new family
 * @route POST /api/v1/families/create
 * @access Private
 */
const createFamily = asyncHandler(async (req, res) => {
  const { family_name, family_surname, city } = req.body;
  const userId = req.user.id;

  // Generate a unique 8-character family code
  let family_code;
  let isCodeUnique = false;
  while (!isCodeUnique) {
    family_code = nanoid(8).toUpperCase();
    const existingFamily = await Family.findOne({ where: { family_code } });
    if (!existingFamily) {
      isCodeUnique = true;
    }
  }

  const transaction = await sequelize.transaction();
  try {
    // Create the family
    const family = await Family.create({
      family_name,
      family_surname,
      city,
      family_code,
    }, { transaction });

    // Add the creator as the first member and an ADMIN
    await UserFamily.create({
      user_id: userId,
      family_id: family.id,
      role: 'ADMIN',
    }, { transaction });

    await transaction.commit();

    return res.status(201).json(new ApiResponse(201, family, 'Family created successfully'));
  } catch (error) {
    await transaction.rollback();
    throw new ApiError(500, 'Failed to create family. Please try again.');
  }
});

/**
 * @description Join an existing family using a family code
 * @route POST /api/v1/families/join
 * @access Private
 */
const joinFamily = asyncHandler(async (req, res) => {
  const { family_code } = req.body;
  const userId = req.user.id;

  const family = await Family.findOne({ where: { family_code } });

  if (!family) {
    throw new ApiError(404, 'Family with this code does not exist.');
  }

  // Check if user is already a member
  const existingMembership = await UserFamily.findOne({
    where: { user_id: userId, family_id: family.id },
  });

  if (existingMembership) {
    throw new ApiError(409, 'You are already a member of this family.');
  }

  // Add user to the family
  await UserFamily.create({
    user_id: userId,
    family_id: family.id,
    role: 'MEMBER', // Default role for joining members
  });

  return res.status(200).json(new ApiResponse(200, { familyId: family.id }, 'Successfully joined the family.'));
});

/**
 * @description Get details of a specific family, including its members
 * @route GET /api/v1/families/:familyId
 * @access Private
 */
const getFamilyDetails = asyncHandler(async (req, res) => {
  const { familyId } = req.params;
  const userId = req.user.id;

  // Authorization check: Ensure the user is a member of the family.
  const membership = await UserFamily.findOne({
    where: {
      user_id: userId,
      family_id: familyId,
    },
  });

  if (!membership) {
    throw new ApiError(403, 'You cannot fetch details for a family you are not a part of.');
  }

  const family = await Family.findByPk(familyId, {
    include: [{ model: User, as: 'members', attributes: ['id', 'first_name', 'last_name', 'email'] }],
  });

  if (!family) {
    throw new ApiError(404, 'Family not found.'); // This case is unlikely if membership exists, but good for data integrity.
  }

  return res.status(200).json(new ApiResponse(200, family, 'Family details fetched successfully.'));
});

export { createFamily, joinFamily, getFamilyDetails };