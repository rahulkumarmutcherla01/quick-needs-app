import { asyncHandler } from '../../utils/asyncHandler.js';
import { ApiResponse } from '../../utils/ApiResponse.js';
import { ApiError } from '../../utils/ApiError.js';
import { Room, Item, UserFamily } from '../../models/index.js';

// --- Room Controllers ---

export const addRoom = asyncHandler(async (req, res) => {
  const { room_name, room_icon, family_id } = req.body;
  const userId = req.user.id;

  // 1. Validate that the user is a member of the provided family
  const membership = await UserFamily.findOne({
    where: {
      user_id: userId,
      family_id: family_id,
    },
  });

  if (!membership) {
    throw new ApiError(403, 'You are not a member of this family.');
  }

  // 2. Create the room
  const room = await Room.create({
    family_id,
    room_name,
    room_icon,
  });

  if (!room) {
    throw new ApiError(500, 'Failed to create the room.');
  }

  return res.status(201).json(new ApiResponse(201, room, 'Room created successfully'));
});

export const getRooms = asyncHandler(async (req, res) => {
  const { family_id } = req.query;
  const userId = req.user.id;

  if (!family_id) {
    throw new ApiError(400, 'family_id query parameter is required.');
  }

  // 1. Validate that the user is a member of the provided family
  const membership = await UserFamily.findOne({
    where: {
      user_id: userId,
      family_id: family_id,
    },
  });

  if (!membership) {
    throw new ApiError(403, 'You are not authorized to view rooms for this family.');
  }

  // 2. Fetch all rooms for the family
  const rooms = await Room.findAll({
    where: { family_id },
    order: [['created_at', 'ASC']],
  });

  return res.status(200).json(new ApiResponse(200, rooms, 'Rooms fetched successfully.'));
});

// --- Item Controllers ---

export const addItemToRoom = asyncHandler(async (req, res) => {
  const { roomId } = req.params;
  const { item_name, quantity, cost } = req.body;
  const userId = req.user.id;

  // 1. Check if the room exists and if the user has access to it
  const room = await Room.findByPk(roomId);
  if (!room) {
    throw new ApiError(404, 'Room not found.');
  }

  const membership = await UserFamily.findOne({
    where: {
      user_id: userId,
      family_id: room.family_id,
    },
  });

  if (!membership) {
    throw new ApiError(403, 'You are not authorized to add items to this room.');
  }

  // 2. Create the item
  const item = await Item.create({
    room_id: roomId,
    item_name,
    added_by_user_id: userId,
    quantity,
    cost,
  });

  if (!item) {
    throw new ApiError(500, 'Failed to add item to the room.');
  }

  return res.status(201).json(new ApiResponse(201, item, 'Item added successfully.'));
});

export const getItemsInRoom = asyncHandler(async (req, res) => {
  const { roomId } = req.params;
  const userId = req.user.id;

  // 1. Check if the room exists and if the user has access to it
  const room = await Room.findByPk(roomId);
  if (!room) {
    throw new ApiError(404, 'Room not found.');
  }

  const membership = await UserFamily.findOne({
    where: {
      user_id: userId,
      family_id: room.family_id,
    },
  });

  if (!membership) {
    throw new ApiError(403, 'You are not authorized to view items in this room.');
  }

  // 2. Fetch all items for the room
  const items = await Item.findAll({
    where: { room_id: roomId },
    order: [['created_at', 'ASC']],
  });

  return res.status(200).json(new ApiResponse(200, items, 'Items fetched successfully.'));
});

export const updateItem = asyncHandler(async (req, res) => {
  const { itemId } = req.params;
  const { item_name, status, quantity, cost } = req.body;
  const userId = req.user.id;

  const item = await Item.findByPk(itemId);
  if (!item) {
    throw new ApiError(404, 'Item not found.');
  }

  // TODO: Add authorization to ensure the user can update this item (is part of the family)

  const updateData = { item_name, status, quantity, cost };
  if (status === 'PURCHASED') {
    updateData.purchased_by_user_id = userId;
    updateData.last_purchased_at = new Date();
  }

  const [updateCount, [updatedItem]] = await Item.update(updateData, {
    where: { id: itemId },
    returning: true,
  });

  if (updateCount === 0) {
    throw new ApiError(500, 'Failed to update the item.');
  }

  return res.status(200).json(new ApiResponse(200, updatedItem, 'Item updated successfully.'));
});
