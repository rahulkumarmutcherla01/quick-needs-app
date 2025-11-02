import { Router } from 'express';
import authRouter from './auth.routes.js';
import familyRouter from './family.routes.js';
import itemRouter from './item.routes.js';
import healthRouter from './health.routes.js';
import chatRouter from './chat.routes.js';
import adminRouter from './admin.routes.js';

const router = Router();

router.use('/auth', authRouter);
router.use('/families', familyRouter);
router.use('/items', itemRouter); // Includes rooms
router.use('/health', healthRouter);
router.use('/chat', chatRouter);
router.use('/admin', adminRouter);

export default router;
