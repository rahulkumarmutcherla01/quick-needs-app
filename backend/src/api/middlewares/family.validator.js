import { z } from 'zod';

export const createFamilySchema = z.object({
  family_name: z
    .string({ required_error: 'Family name is required' })
    .min(1, 'Family name cannot be empty'),
  family_surname: z.string().optional(),
  city: z.string().optional(),
});

export const joinFamilySchema = z.object({
  family_code: z.string({ required_error: 'Family code is required' })
    .length(8, 'Family code must be 8 characters long'),
});