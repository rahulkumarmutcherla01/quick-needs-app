import { Router } from 'express';
import { createFamily, joinFamily, getFamilyDetails } from '../controllers/family.controller.js';
import { verifyJWT } from '../middlewares/auth.middleware.js';
import { validate } from '../middlewares/validate.middleware.js';
import { createFamilySchema, joinFamilySchema } from '../middlewares/family.validator.js';

const router = Router();

// All family routes require authentication
router.use(verifyJWT);

router.post('/create', validate(createFamilySchema), createFamily);
router.post('/join', validate(joinFamilySchema), joinFamily);
router.get('/:familyId', getFamilyDetails);

export default router;