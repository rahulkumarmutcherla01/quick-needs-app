import { asyncHandler } from '../../utils/asyncHandler.js';
import { ApiResponse } from '../../utils/ApiResponse.js';
import { ApiError } from '../../utils/ApiError.js';

export const addMedication = asyncHandler(async (req, res) => {
  // TODO: Implement logic to add a new medication for a family member
  // 1. Get user_id (person who needs it), medicine_name, dosage, instructions from req.body
  // 2. Get family_id from the logged-in user's family membership
  // 3. Create the medication in the DB
  return res.status(201).json(new ApiResponse(201, {}, "Medication added. Controller logic to be implemented."));
});

export const getMedications = asyncHandler(async (req, res) => {
  // TODO: Implement logic to get all medications for the user's family
  return res.status(200).json(new ApiResponse(200, [], "Medications fetched. Controller logic to be implemented."));
});

export const addMedicationSchedule = asyncHandler(async (req, res) => {
  const { medicationId } = req.params;
  // TODO: Implement logic to add/update a schedule for a medication
  return res.status(200).json(new ApiResponse(200, { medicationId }, "Medication schedule set. Controller logic to be implemented."));
});

export const logMedicationDose = asyncHandler(async (req, res) => {
  const { scheduleId } = req.params;
  // TODO: Implement logic to log that a dose has been taken
  return res.status(201).json(new ApiResponse(201, { scheduleId }, "Medication dose logged. Controller logic to be implemented."));
});

export const getMedicationLogs = asyncHandler(async (req, res) => {
  const { scheduleId } = req.params;
  // TODO: Implement logic to get compliance history for a medication
  return res.status(200).json(new ApiResponse(200, { scheduleId, logs: [] }, "Medication logs fetched. Controller logic to be implemented."));
});

