import { Router } from 'express';
import {
  loginSuperAdmin,
  getAdvertisements,
  createAdvertisement,
  updateAdvertisement,
  deleteAdvertisement,
} from '../controllers/admin.controller.js';
// import { verifySuperAdminJWT } from '../middlewares/adminAuth.middleware.js'; // A separate auth middleware for admins is recommended

const router = Router();

router.post('/login', loginSuperAdmin);

// The following routes should be protected by an admin-specific auth middleware
// router.use(verifySuperAdminJWT);

router.route('/advertisements').get(getAdvertisements).post(createAdvertisement);
router.route('/advertisements/:adId').put(updateAdvertisement).delete(deleteAdvertisement);

export default router;