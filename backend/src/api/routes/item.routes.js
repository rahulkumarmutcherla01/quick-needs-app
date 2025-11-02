import { Router } from 'express';
import { verifyJWT } from '../middlewares/auth.middleware.js';
import {
  addRoom,
  getRooms,
  addItemToRoom,
  getItemsInRoom,
  updateItem,
} from '../controllers/item.controller.js';

const router = Router();

// All item/room routes will be protected
router.use(verifyJWT);

// Room routes (handled under the `/items` prefix as per index.js)
router.route('/rooms').post(addRoom).get(getRooms);

// Item routes
router.route('/rooms/:roomId/items').post(addItemToRoom).get(getItemsInRoom);
router.route('/:itemId').put(updateItem);

export default router;
