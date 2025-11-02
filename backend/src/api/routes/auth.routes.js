import { Router } from 'express';
import { registerUser, loginUser, getCurrentUser } from '../controllers/auth.controller.js';
import { verifyJWT } from '../middlewares/auth.middleware.js';
import { validate } from '../middlewares/validate.middleware.js';
import { registerUserSchema, loginUserSchema } from '../middlewares/auth.validator.js';

const router = Router();

router.post('/register', validate(registerUserSchema), registerUser);
router.post('/login', validate(loginUserSchema), loginUser);
router.get('/me', verifyJWT, getCurrentUser);

export default router;
