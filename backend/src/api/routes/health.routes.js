import { Router } from 'express';
import { verifyJWT } from '../middlewares/auth.middleware.js';
import {
  addMedication,
  getMedications,
  addMedicationSchedule,
  logMedicationDose,
  getMedicationLogs,
} from '../controllers/health.controller.js';

const router = Router();

// All health routes are protected
router.use(verifyJWT);

router.route('/medications').post(addMedication).get(getMedications);

router.route('/medications/:medicationId/schedule').post(addMedicationSchedule);

router.route('/schedules/:scheduleId/log').post(logMedicationDose);
router.route('/schedules/:scheduleId/logs').get(getMedicationLogs);

export default router;