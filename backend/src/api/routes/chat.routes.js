import { Router } from 'express';
import { verifyJWT } from '../middlewares/auth.middleware.js';
import {
  getConversations,
  startConversation,
  getMessagesForConversation,
  sendMessage,
} from '../controllers/chat.controller.js';

const router = Router();

// All chat routes are protected
router.use(verifyJWT);

router.route('/conversations').get(getConversations).post(startConversation);

router.route('/conversations/:conversationId/messages').get(getMessagesForConversation).post(sendMessage);

export default router;